static import portaudio;

import std.meta;
import std.stdio;
import std.traits;
import core.sys.windows.windows;

struct Tuple(_FuncType, string _Name) {
    alias FuncType = _FuncType;
    enum Name = _Name;
}

/* Get the function pointer type of an actual function */
template FuncType(alias symbol) {
    ReturnType!symbol function(Parameters!symbol) func;
    alias FuncType = SetFunctionAttributes!(typeof(func), functionLinkage!symbol,
        functionAttributes!(typeof(func)));
}

/* Get a sequence of (Function type, Name) belonging to the provided module */
template GetFunctionList(alias Module) {
    alias GetFunctionList = AliasSeq!();
    static foreach (idx, member; __traits(allMembers, Module)) {
        static if (isFunction!(__traits(getMember, Module, member))) {
            GetFunctionList = AliasSeq!(GetFunctionList,
                Tuple!(FuncType!(__traits(getMember, Module, member)), member));
        }
    }
}

/* Generate dynamic bindings for all functions in Module and load SharedLib */
class Dynamic(alias Module, string SharedLib)
{
    /* Load the shared library */
    static HANDLE dll;
    static this() {
        dll = LoadLibraryA(SharedLib);
        !dll && assert(0);
    }

    /* Declare the function pointers */
    static foreach (Tup; GetFunctionList!Module) {
        mixin("Tup.FuncType " ~ Tup.Name ~ ";");
    }

    /* Load the function pointers */
    this()
    {
        static foreach (Tup; GetFunctionList!Module) {
            *(cast(void**)&__traits(getMember, this, Tup.Name))
                = cast(void*)GetProcAddress(dll, Tup.Name);
        }
    }
}

void main() {
    // easy!
    auto dynamic = new Dynamic!(portaudio, "portaudio_x64.dll");
    printf("Version info %s\n", dynamic.Pa_GetVersionText());
}
