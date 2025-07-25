//! Given the results of `read.zig`'s parsing, outputs an `extern "C"` compatible .cpp file for FFI
//! usage.
//! 
//! > Why generate zig code with extern functions instead of a c header via translate-c?
//! > Ultimately it comes down to not having to re-create the C++ types in the C header,
//! > having more control over the output (i.e. associated methods), and just an overall
//! > want to stay as zig-centric as possible. As well as only having to meet an ABI
//! > requirement for function parameters and return types.

