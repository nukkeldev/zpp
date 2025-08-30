# Architecture v0.1

This document details this project's architecture and should serve as the primary reference 
alongside the source code for implementing new features. Any amendments to this document should be 
reflected in the source code and vice versa.

## Overview

`zpp` is composed of a library and a frontend (unfortunately the distinction is not yet clearly defined).
The library is further broken into two components: the intermediate representation and the writers.
The frontend serves as a simple way to interface with the library but will not be the primary method.
Rather, a programmatic configuration system via a user's `build.zig` will be the intend use case.
No further elaboration in this document on the frontend will happen until the later system is implemented.

## Intermediate Representation

The intermediate representation component handles interfacing with `libclang`'s visitor API and parsing 
the AST nodes into a flat list of instructions. `Instruction`s are all named (via `libclang`'s spelling of the cursor) 
and can be one of the following eight types:
- Namespace
  - Declares the children to be contained in the namespace of the instruction's name.
  - Namespaces, structs, enums, unions, and functions are allowed as children.
- Struct
  - Declares a structure of the instruction's name.
  - Members, namespaces, structs, enums, unions, and functions are allowed as children.
- Union
  - If the parent _is not_ a struct or union, declares a new union of the instruction's name.
  - If the parent _is_ a struct or union: 
    - If the union is anonymous, declares an anonymous union member.
    - Otherwise, declares a new union of the instruction's name.
- Enum
  - Declares an unscoped enum of the instruction's name.
  - Stores the underlying integral type.
- Function
  - Declares a function of the instruction's name.
  - Stores the return type and whether the function has a variable argument.
- Member
  - If the parent _is_ a struct or union, declares a new data member.
  - If the parent _is_ a function, declares a new parameter.
  - Any other occurrence is invalid.
  - Does not have a closing instruction.
- Value
  - If the parent _is_ an enum, declares a new enum value.
  - Any other occurrence is invalid.
  - Does not have a closing instruction.
- Type Definition
  - Declares an alias of the instruction's name.
  - The target type is accessed through the cursor.

Furthermore, most of the instructions come in pairs, one opening and one closing, to denote scopes;
instructions between them are referred to as children or child instructions. Unfortunately, the chosen
representation of instructions' associated information leads to contention as instructions also store
references to their source `libclang` `CXCursor`, in which all the associated information is immediately
available.

The `IR` struct contains the aforementioned instruction list (`instrs: std.array_list.Managed(Instruction)`)
and is directly modified during `libclang` visiting hours. Additionally, it contains an arena allocator 
(`arena: std.heap.ArenaAllocator`), an ordered list of the paths of cursors it ingests (`paths`), and a 
hash set of the same (`hashed_paths: std.StringHashMap(void)`). The `IR` needs to be aware of where the 
sources came from for later steps.

### Visiting

The visiting process passes around a pointer to arbitrary client data (`ProcessingState`) which contains:
- An allocator (`allocator: std.mem.Allocator`)
- A pointer to the currently modified `IR` (`ir: *IR`)
- A pointer to a hash-map of namespace names to corresponding `IR`s (`namespaces: *std.StringHashMap(IR)`)
- And an error for propagation (`err: ?anyerror`)

The process begins as follows:
1. Given:
   1. an allocator (`allocator`), 
   2. a zero-terminated path to the root/main file to be processing (`root_path`),
   3. the contents of said root path (`contents`),
   4. a list of filesystem paths that we'd like to whitelist cursors of (`paths`),
   5. and a list of zero-terminated arguments to pass to clang (`clang_args`).
2. Create an `CXUnsavedFile` for the root path (`file`).
   - `libclang` can either read a file's contents from memory (via an unsaved file) or from the
     filesystem (with either the main/root file path or included files referred to from the root file).
   - The file's path may be arbitrary as it's only an identifier to the unsaved file itself. This allows
     us to process multiple files at once by writing an empty file except includes.
3. Call `clang_parseTranslationUnit` and store it in `translation_unit`, 
   1. specifying the main file to `file`'s path,
   2. and passing in the `clang_args`.
4. If either `translation_unit` is null _or_ one of the emitted diagnostics is fatal, throw an error.
   - Unfortunately, fatal diagnostics just panic the program currently.
5. Get the root `cursor: CXCursor` for the `translation_unit`.
6. Initialize the root `IR`.
7. Initialize the processing state (`state`):
   1. with `allocator` being an instance of the root `IR`'s arena,
   2. and `ir` pointing to the root `IR`.
8. Call `clang_visitChildren` with
   1. `cursor`, 
   2. the later described callback function `outerVisitor`,
   3. and a type-erased pointer to the processing state.
9. With the now populated `state`, merge the namespaces the root `IR` by:
   1.  Iterate through the instructions.
   2.  If a namespace is found, look it up in `state.namespaces`:
       1.  If it is contained, remove it and insert the instructions between the open and close namespace
           instructions.
       2.  Otherwise, remove the open and close instructions as it has already been processed.
10. Then, to meet Zig's ordering requirements, reorganize struct and union children to have declarations
    after members by:
    1. Iterate through all the instructions.
    2. If we reach a member or anonymous union _and_ our immediate parent is a struct or named union:
       1. If we know the index of the previous member or anonymous union _and_ it is _not_ the current index:
          1. Move the member or anonymous union there.
       2. Store the index of the subsequent _sibling_.
11. Return the root `IR`.

For the `outerVisitor`:
1. Supplied with `current_cursor: c.CXCursor` and `client_data_opaque: c.CXClientData`.
2. Cast the `client_data_opaque` back to a pointer of processing state (`state`).
3. Get the location of the `current_cursor`, if the location's file is _not_ in `state.ir.hashed_paths`:
   1. Return `CXChildVisit_Continue`, which continues to the next sibling or parent cursor.
4. Call `visitor` and save the result (`?Instruction`).
   - Due to the callback needing to be the exact signature of what `libclang` expects, using fallible
     functions is painful, so we consolidate the error catching to one spot.
5. If the result is null, skip to step 10.
6. Add the instruction to `state.ir`.
7. If the instruction is a namespace:
   1. Get or create (with the same paths) the namespace in `state.namespaces`.
   2. Save the current `state.ir`.
   3. Call `clang_visitChildren` with the instruction's cursor.
   4. Restore `state.ir`.
8. If the instruction is _not_ a member, value, or type definition:
   1. Call `clang_visitChildren` with the instruction's cursor.
9. Duplicate the instruction, mark it as a close instruction, and append it to `state.ir`.
10. If `state.err` is set, return `CXChildVisit_Break` to halt the visiting process.
11. Return `CXChildVisit_Continue`.

And finally, for `visitor`:
1. Supplied with `allocator: std.mem.Allocator`, `cursor: c.CXCursor`, and `ir: *IR`.
2. Get the `name` of the cursor with `clang_getCursorSpelling`.
3. If the cursors lexical and semantic parents are not the same, return null as we do not want to handle
   non-"canonical" cursors.
   - I'm not sure if the condition is equivalent to whether a cursor is canonical.
4. Switching on the instruction kind, mapping between cursor kinds and instruction is basically 1-to-1.
5. Return the instruction.

That concludes the `IR` construction process. Overall the process is quite simple because:
- Parsing is non-contextual, allowing for possible future parallel processing.
  - While I believe this to be a point of performance improvement, this should not be done until after
    profiling with Tracy.
- `libclang` has sane node kinds.

### C++ Type Handling

`libclang` provides us with `CXType`s which are not ideal to work with (i.e. too many integer types, etc.).
We convert any `CXType` into a `TypeReference`; a thin-wrapper that is similar to instructions.
`TypeReference`s store whether the type is const, a tagged-union to identify the type kind, and the 
underlying `CXType`.

Some notes on the parsing implementation:
- `Record`s and `Enum`s verify whether the type is in-scope... but it doesn't really do anything with that.
- `Record`s additionally filter out templated types as a `unexposed` type.

While removing the tagged-union on instructions would be beneficial; that's not the case here as kind's are
not fully distinct.

### Suggested Improvements

- Remove associated information from instructions; purely fallback on the cursors.
  - Do we need to store the spelling of the cursor? I don't believe we have an immediate need for it.
  - Furthermore, are instructions needed at all? Could we not just return a filtered list of cursors?
    - If we were to remove the name and reduce the inner to an enum instead of a tagged union; would that
      not just be the same as the cursor itself? The only situation I see where the prior may be beneficial
      is if cursor -> instructions aren't a 1-to-1 mapping; such might happen for default values.
- Simplify the processing state:
  - Remove the namespace map; record all instruction in a single `IR`. Use post-processing to merge namespaces.
  - Remove the `allocator`; get the `IR`'s allocator instead.
- Distinguish between unscoped (`enum`) and scoped enums (`enum class` or `enum struct`).
- Store a relative offset between an instruction and it's parent.
  - Ensure this is updated during post-processing.
- Clarify the behavior of canonical cursors with lexical and semantic parents.
  - All non-obvious parts of `libclang` should have test cases to check its behavior.

In summary, simplify everything.

## Writers
> Two writers `CppWrapper` and `ZigWrapper` are currently implemented.

All writers are implementations of a common interface/v-table: `IRWriter`. The interface has four function
pointers:
- `formatFilename`: Given an allocator and the source filename, returns the file the writer should output to.
  - Our implementations just suffix the proper extension on the filename (`.cpp` for C++ and `.zig` for Zig).
- `formatFile`: The majority of the writing; Given a `IR` and a `*std.Io.Writer`, writes to the file.
- `postProcessFile`: Given an allocator and the output filename, does any post-processing like formatting.
- `checkFile`: Given an allocator, the output filename, and writer-specific information, verify the file compiles.

The first three functions are invoked in the common function `writeToFile`; whereas checking is a separate function
`checkFile`.

Formatting implementations are largely the same: initialize context, iterate through instructions, write to the writer,
update context, repeat.

### C++

Mind the preamble, C++ serialization begins with initializing four bits of context:
- A map of function names to their occurrence count to handle function overloading.
- A stack of our current and parent namespaces.
- A list of instructions for functions' parameters; required to implement the function bodies. 
- A stack of our current and parent contexts (one of: `struct_like`, `ignore_members`, `function`, or `root`)

Following this we iterate through the instructions, writing outputs and updating context as necessary.

Instruction serialization is separated by whether the instruction is opening or closing. A lot of nuance is
needed for functions to handle combinations of, for instance, variable arguments, struct return types (and
thus needing an out pointer parameter), etc.

C++ serialization is a lot easier as we only have to deal with the functions.

As for C++ types, it's basically the reverse of the earlier parsing: integer of bit-widths back to their keywords,
records by name, etc. The main difficulties with the process are:
- Not duplicating consts, and putting them in the right place (which I'm not sure if we're doing; should probably check 
  that).
- Function pointers.

### Zig

On the other hand, Zig serialization is significantly more complex (2x the length) as it needs to 
duplicate C++ types in an ABI correct manner (further asserted by `comptime` size and alignment checks 
per struct and per field) along with the functions.

We have the same state as C++ with two differences:
- An addition map of forward declarations that can be resolved to opaque types if not implemented.
  - This could possibly be removed if we get the type of the cursor and check if it's incomplete.
- And more choices for context, some with additional state.

The iteration process is also largely the same, except that all the instructions have implementations for both
open and closing. Type writing is also a lot simpler as integers can be variable bit-widths and most other types
can be identified by name.

### Suggested Improvements

- BUFFER THE WRITERS.
- Make a common context state to handle the instruction loop out of the `formatFile` function.
  - Thus, allowing the writers to easily undo serializations that error; we currently have no way to do this easily.
- Wrap the writer formatting implementations in an inner function to reduce the amount of catches for fallible functions.