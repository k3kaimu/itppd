module itppd.base.binary;

import itppd.wrapper;


enum ITPP_BASE_BINARY =
q{
    struct bin
    {
        char b;
    }
};


enum ITPP_BASE_BINARY_W = "";


struct Bin
{
    this(int value)
    in{
        assert(value == 0 || value == 1);
    }
    do{
        _impl.b = cast(char)(value != 0 ? 1 : 0);
    }


    bool opCast(T : bool)() const
    {
        return _impl.b != 0;
    }


    void opAssign(Int : long)(Int rhs)
    in{
        assert(rhs == 0 || rhs == 1);
    }
    do{
        _impl.b = cast(char)(rhs != 0 ? 1 : 0);
    }


    bool opEquals(Int :  long)(Int rhs) const
    {
        return rhs == _impl.b;
    }


    alias _impl this;
    itpp.bin _impl = {b:0};
}

unittest
{
    Bin b0;
    assert(b0 == 0);
    assert(!b0);

    b0 = 1;
    assert(b0 == 1);
    assert(b0);
}
