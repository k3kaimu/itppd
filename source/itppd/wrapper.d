module itppd.wrapper;

extern(C++, std)
{
    struct complex(T)
    {
        T re;
        T im;
    }
}

alias stdcomplex = std.complex;

mixin(WrapperGen.genITPPWrappers([
    "itpp.base.binary",
    "itpp.base.factory",
    "itpp.base.vec",
    "itpp.comm.ldpc",
]));


private
struct WrapperGen 
{
    import std.algorithm;
    import std.ascii;
    import std.format;
    import std.string;

    static:
    private:
    string genITPPWrappers(string[] modules)
    {
        string imports;
        foreach(mod; modules) {
            imports ~= format("import %s : %s, %s;\n",
                toDModuleName(mod),
                toMixinMacroITPP(mod),
                toMixinMacroITPPW(mod)
            );
        }

        string externitpp;
        foreach(mod; modules) {
            externitpp ~= format("mixin(%s);\n",
                toMixinMacroITPP(mod)
            );
        }

        string externitppw;
        foreach(mod; modules) {
            externitppw ~= format("mixin(%s);\n",
                toMixinMacroITPPW(mod)
            );
        }

        return format(q{
            %s

            extern(C++, itpp)
            {
                %s
            }

            extern(C++, itppw)
            {
                %s
            }
        }, imports, externitpp, externitppw);
    }


    string toDModuleName(string mod)
    {
        string[] ns = mod.split(".");
        ns[0] ~= 'd';
        return ns.join(".");
    }


    string toMixinMacroITPP(string mod)
    {
        string[] ns = mod.split(".");
        return ns.map!toUpper.join("_");
    }


    string toMixinMacroITPPW(string mod)
    {
        string[] ns = mod.split(".");
        ns ~= "W";
        return ns.map!toUpper.join("_");
    }
}