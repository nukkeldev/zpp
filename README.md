# `zpp`
> ABI correctness is hopefully guaranteed.

[![License: AGPL v3](https://img.shields.io/badge/License-AGPL_v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![Zig: Master](https://img.shields.io/badge/Zig-master-color?logo=zig&color=%23f3ab20)](https://ziglang.org)

Generates Zig bindings for (a subset of) C++ headers.
Built on `libclang`'s `Index` API.

## Usage

```
Usage: zpp <header-path> [OPTIONS]
Generates C-compatible header files from (a subset of) C++ headers. 

Required Arguments:
    <header-path>       The path to the C++ header

Optional Arguments:
    -x,  --clang-arg    Passes the subsequent argument through to clang.
    -s,  --sandbox      Enables the generation of a zig project to experiment with the results
```

## TODO

- [ ] Disparate sets of namespaced declarations.
    ```cpp
    namespace N { void foo(); }
    void bar();
    namespace N { void baz(); }
    ```
  - The members of namespaces are not merged, resulting in duplicate Zig struct members. Instead, we could have namespaced declarations go to their own files which would eliminate the issue.
- Excessive usage of `@panic`
  - Localize issues to individual declarations and keep them syntactically correct or buffer each one so they can be deleted.
- Bad C string dx
  - `const char*` -> `[*c]const i8` which needs a `@ptrCast`, only a slight annoyance though.
  - Further generate more "zig-like" bindings that can format common patterns more appropriately. 