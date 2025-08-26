// This file provides examples of all supported features of `zpp` as well as their expected
// conversion behavior in plain-text with the EX prefix.
//
// TODO: This is a heavy WIP as I add and discover more C/C++ features.

// EX: Ignored
#include <stdio.h>
// #include <vector>

// EX: Ignored
using namespace std;

// -- Forward Declarations -- //

// EX: Ignored
struct Struct;
// EX: Ignored
union Union;

// -- Structs -- //

// EX: `extern struct {}`
// TODO: This is currently converted to an opaque struct due to it having no fields and us having no
// TODO: determinate for that being valid.
struct ZST
{
};

// EX: `extern struct { x: i32, y: i32 }`
struct POD
{
    int x, y;
};

// EX: `extern struct { x: i32 = 4, y: i32 = 5 }`
// TODO: Default field values are not handled yet.
struct Struct
{
    int x = 4;
    int y = 5;
};

// EX: `extern struct {
//     x: i32,
//     anon0: extern union {
//         y: f32,
//         z: f64,
//         w: i8,
//     }
// }`
// NOTE: Unnamed fields are named `anon#`
struct StructWithAnonymousUnion
{
    int x;
    union
    {
        float y;
        double z;
        char w;
    };
};

// -- Enums -- //

// EX: `packed struct(i32) {
//     data: i32,
//     pub const A: Enum = .{ .data = 0 };
//     pub const B: Enum = .{ .data = 2 };
//     pub const C: Enum = .{ .data = 1 };
// }`
enum Enum
{
    A,
    B = 2,
    C = 1,
};

// -- Unions -- //

// EX: `extern union {
//    x: i32,
//    y: f32,
//    z: [*c]i8,
// }
union Union
{
    int x;
    float y;
    char *z;
};

// -- Functions -- //

// EX: `fn () callconv(.c) void`
void ret_void()
{
    printf("ret_void");
}

// EX: `fn (i32) callconv(.c) void`
void one_prim_ret_void(int param1)
{
    printf("one_prim_ret_void");
}

// EX: `fn (i32, i32, i32) callconv(.c) void`
void n_prim_ret_void(int param1, int param2, int param3)
{
    printf("n_prim_ret_void");
}

// EX: `fn (i32, ...) callconv(.c) void`
// EX: varargs forwarded in extern "C" wrapper
void one_prim_vararg_ret_void(int n, ...)
{
    printf("one_prim_vararg_ret_void");
}

// EX: `fn ([*c]i32) callconv(.c) void`
// TODO: I'm not sure if there is a way to distinguish whether a many-item or single-item pointer is expected.
// TODO: Sure, we could generate both of them but that's quite ugly.
void one_ptr_ret_void(int *x)
{
    printf("one_ptr_ret_void");
}

// EX: `fn ([*c]const i32) callconv(.c) void`
// TODO: ^
void one_const_ptr_ret_void(const int *x)
{
    printf("one_const_ptr_ret_void");
}

// EX: `fn (*i32) callconv(.c) void`
// EX: deref x (int* -> int&) when passing
void one_ref_ret_void(int &x)
{
    printf("one_ref_ret_void");
}

// EX: `fn ([*]i32) callconv(.c) void`
// NOTE: "arrays are not allowed as a parameter type" - zig 0.15.1
void one_arr_ret_void(int color[4])
{
    printf("one_arr_ret_void");
}

// EX: `fn ([*]i32) callconv(.c) void`
void one_slice_ret_void(int color[])
{
    printf("one_slice_ret_void");
}

// EX: `fn (i32) callconv(.c) void`
// TODO: We do not currently handle default function arguments. There are many ways we could handle them:
// TODO: - Generate a separate function for each combination of default arguments... (honestly disgusting)
// TODO: - Wrap default parameters in a struct with the default values set (honestly quite good)
void one_prim_def_val_ret_void(int x = 3)
{
    printf("one_prim_def_val_ret_void");
}

// EX: `fn (?*anyopaque) callconv(.c) void`
// TODO: Honestly, it might be better to just filter out functions like these.
// void one_unexposed_ret_void(vector<int> vec) {
//     printf("one_unexposed_ret_void");
// }

// EX: `fn () callconv(.c) i32`
int ret_prim()
{
    printf("ret_prim");
    return 42;
}

// EX: `fn (*POD) callconv(.c) void`
// NOTE: For struct return types, we output them through output pointers.
POD ret_pod()
{
    printf("ret_pod");
    POD s;
    s.x = 3;
    s.y = 3;
    return s;
}

// EX: `fn (*Struct) callconv(.c) void`
// NOTE: ^+ this allows us to not have to convert non-POD structs into extern "C" compatible ones in C++.
Struct ret_struct()
{
    printf("ret_struct");
    Struct s;
    s.x = 4;
    s.y = 3;
    return s;
}

// EX: `fn () callconv(.c) Enum`
Enum ret_enum()
{
    printf("ret_enum");
    return Enum::A;
}

// EX: `fn (*Union) callconv(.c) void`
Union ret_union()
{
    printf("ret_union");
    Union u;
    u.x = 3;
    return u;
}

// EX: `fn () callconv(.c) [*c]i32`
int *ret_ptr()
{
    printf("ret_ptr");
    return nullptr;
}

// EX: `fn () callconv(.c) [*c]const i32`
const int *ret_const_ptr()
{
    printf("ret_const_ptr");
    return nullptr;
}

// EX: `fn (i32, *Struct, ...) callconv(.c) void`
// EX: The vararg forwarding must correctly address the output param for `va_start`.
Struct one_prim_vararg_ret_struct(int s, ...)
{
    Struct c;
    c.x = 45;
    c.y = 12;
    return c;
}

// -- Namespaces -- //

// EX: `struct NS1 { ... }`
namespace NS1
{
    // EX: Previously covered.
    int foo()
    {
        printf("NS1::foo");
        return 52;
    }
    // EX: Previously covered.
    void bar(int baz)
    {
        printf("NS1::bar");
    }
}

// EX: Previously covered.
void after_ns()
{
    printf("after_ns");
}

// EX: Members merged with above and this instance removed.
namespace NS1
{
    // EX: Previously covered.
    int foo2()
    {
        return 32;
    }
}
