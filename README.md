# `zpp`

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Zig: 0.15.1](https://img.shields.io/badge/Zig-0.15.1-color?logo=zig&color=%23f3ab20)](https://ziglang.org)

Zig binding generator for C/C++ libraries. 

Supported features include:
- Namespaced Declarations
- Struct, Union, and Enum Declarations
- Functions
- Type Aliases
- Opaque Types
- Forward Declaration Filtering
  - Unfortunately, the current implementation keeps the declaration in-place
    instead of moving it to the first forward declaration.
- `comptime` ABI Verification
- Member Functions

See and compile [supported.hpp](src/embed/testing/supported.hpp) for a more complete list.

Planned features include:
- Default Function Parameters
- Default Struct Field Values
- Programmatic Configuration In `build.zig`
- Classes
- Templates
  - Probably not for quite a while, but I have implementation ideas.

## Usage

### CLI

```
Usage: zpp <header-path> [OPTIONS]
Generates C-compatible header files from (a subset of) C++ headers. 

Required Arguments:
    <header-path>       The path to the C++ header

Optional Arguments:
    -x,  --clang-arg    Passes the subsequent argument through to clang.
    -s,  --sandbox      Enables the generation of a zig project to experiment with the results
```

### Bindings

`zpp` outputs Zig bindings and an accompanying C-compatible C++ wrapper.
The files are plug-and-play (**if not, please file an issue**), put them in a
module along with the source, import them into your program, and it should work.
Please see the examples for, well, examples.

## License

`zpp` is licensed under the `AGPL v3` license. Please see [LICENSE](LICENSE) 
for more information.

`zpp` links against, but does not bundle or distribute:
- `libclang`, part of the [LLVM Project](https://llvm.org/), licensed under the `Apache License v2.0 with LLVM Exceptions`.