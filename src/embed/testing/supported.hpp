// Notes:
// - typedefs are resolved at usage site currently.

#include <stdio.h>
#include <vector>

using namespace std;

// -- Forward Declarations -- //

struct Struct;
union Union;

// -- Zero-sized Type -- //

struct ZST {};

// -- Parameters -- //

void ret_void()
{
    printf("ret_void");
}

void one_prim_ret_void(int param1)
{
    printf("one_prim_ret_void");
}

void n_prim_ret_void(int param1, int param2, int param3)
{
    printf("n_prim_ret_void");
}

void one_prim_vararg_ret_void(int n, ...)
{
    printf("one_prim_vararg_ret_void");
}

void one_ptr_ret_void(int *x)
{
    printf("one_ptr_ret_void");
}

void one_const_ptr_ret_void(const int *x)
{
    printf("one_const_ptr_ret_void");
}

void one_ref_ret_void(int &x)
{
    printf("one_ref_ret_void");
}

void one_arr_ret_void(int color[4])
{
    printf("one_arr_ret_void");
}

void one_slice_ret_void(int color[])
{
    printf("one_slice_ret_void");
}

// TODO: We do not currently handle default function arguments.
void one_prim_def_val_ret_void(int x = 3)
{
    printf("one_prim_def_val_ret_void");
}

// NOTE: Not POD; non-goal.
// TODO: Filter functions like these out.
// void one_unexposed_ret_void(vector<int> vec) {
//     printf("one_unexposed_ret_void");
// }

// -- Return Values -- //

int ret_prim()
{
    printf("ret_prim");

    return 42;
}

struct POD
{
    int x, y;
};

POD ret_pod()
{
    printf("ret_pod");

    POD s;
    s.x = 3;
    s.y = 3;
    return s;
}

struct Struct
{
    int x = 4;
    int y = 5;
};

Struct ret_struct()
{
    printf("ret_struct");

    Struct s;
    s.x = 4;
    s.y = 3;
    return s;
}

enum Enum
{
    A,
    B = 2,
    C = 1,
};

Enum ret_enum()
{
    printf("ret_enum");

    return Enum::A;
}

union Union
{
    int x;
    float y;
    char *z;
};

Union ret_union()
{
    printf("ret_union");

    Union u;
    u.x = 3;

    return u;
}

int *ret_ptr()
{
    printf("ret_ptr");
    return nullptr;
}

const int *ret_const_ptr()
{
    printf("ret_const_ptr");
    return nullptr;
}

// -- Edge Cases -- //

Struct one_prim_vararg_ret_struct(int s, ...) {
    Struct c;
    c.x = 45;
    c.y = 12;
    return c;
}

// -- Namespaces -- //

namespace NS1
{
    int foo()
    {
        printf("NS1::foo");
        return 52;
    }
    void bar(int baz) {
        printf("NS1::bar");
    }
}

void after_ns() {
    printf("after_ns");
}

namespace NS1
{
    int foo2() {
        return 32;
    }
}

// -- Classes -- //

// TODO:
// class Class {
// };

// TODO: Templates