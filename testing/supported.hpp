// Notes:
// - typedefs are resolved at usage site currently.

// -- Parameters -- //

void ret_void();

void one_prim_ret_void(int param1);

void n_prim_ret_void(int param1, int param2, int param3);

void one_prim_vararg_ret_void(int n, ...);

void one_ptr_ret_void(int *x);

void one_const_ptr_ret_void(const int *x);

void one_ref_ret_void(int& x);

// -- Return Values -- //

int ret_prim();

struct Struct {
    // TODO: Default values
    int x = 4;
    int y = 5;
};

Struct ret_struct();

enum Enum {
    A,
    B = 2,
    C = 1,
};

Enum ret_enum();

// TODO: Compiles but `Union` not emitted.
//
// union Union {
//     int x;
//     float y;
//     char* z;
// };
//
// Union ret_union();

int &ret_ref();

// -- Namespaces -- //

// TODO: Namespaces are not reconstructed on the Zig-side yet.
namespace NS1 {
    int foo();
    void bar(int baz);
}

// TODO: Classes ((de)constructors, member methods, etc.);
// TODO: Templates