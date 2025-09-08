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

See `examples/` and `tests/` for a more complete list of supported features.

## Tested Against

- [ImGui](https://github.com/ocornut/imgui/tree/b7cb3d93a419ffa9c37c2150eda695f3f43c221f)
- [ImPlot](https://github.com/epezent/implot/tree/3da8bd34299965d3b0ab124df743fe3e076fa222)
- [ImPlot3D](https://github.com/brenocq/implot3d/tree/c3af49c930f09a10a0e460d64189e7733939fe51)

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
