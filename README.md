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