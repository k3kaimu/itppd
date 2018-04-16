module itppd.base.vec;

import std.algorithm;
import std.complex;
import std.conv;
import std.format;
import std.range : isOutputRange;

import itppd.base.factory;
import itppd.base.binary;
import itppd.base.wrapper;


/++
IT++のitpp::Vec<T>に対応する型です．
+/
struct Vec(T)
if(is(T == int) || is(T == short) || is(T == double) || is(T == Complex!double) || is(T == Bin))
{
    this(size_t n)
    {
        _impl.set_length(n.to!int);
        this.ptr[0 .. n] = T.init;
    }


    this(in T[] slice)
    {
        this(slice.length);
        this.ptr[0 .. slice.length] = slice[];
    }


    this(this)
    {
        auto p = _impl.data;
        auto s = _impl.datasize;
        _impl.datasize = 0;
        _impl.data = null;
        _impl.set_length(s);
        _impl.data[0 .. s] = p[0 .. s];
    }


    size_t length() const @property
    {
        return _impl.length;
    }


    void length(size_t newlen) @property
    {
        immutable old = this.length;
        _impl.set_length(newlen.to!int, true);
        this.ptr[old .. newlen] = T.init;
    }


    inout(T)* ptr() inout @property @trusted
    {
        return cast(typeof(return))_impl.data;
    }


    size_t opDollar(size_t dim)() const @property
    {
        return this.length;
    }


    void zeros() { _impl.zeros(); }
    void ones() { _impl.ones(); }
    

    ref inout(T) opIndex(size_t i) inout
    in{
        assert(i < this.length);
    }
    do{
        return this.ptr[i];
    }


    Vec!T opBinary(string op : "~")(auto ref const Vec!T rhs) const
    {
        Vec!T dst;
        dst.length = this.length + rhs.length;
        dst.opIndex()[0 .. this.length] = this.opIndex()[];
        dst.opIndex()[this.length .. $] = rhs.opIndex()[];
        return dst;
    }


    ref Vec!T opOpAssign(string op : "~")(auto ref const Vec!T rhs) return
    {
        immutable oldlen = this.length;
        immutable rhslen = rhs.length;
        this.length = this.length + rhs.length;

        this.opIndex()[oldlen .. oldlen + rhslen] = rhs.opIndex()[0 .. rhslen];

        return this;
    }


    inout(T)[] opIndex() inout
    {
        return this.ptr[0 .. _impl.datasize];
    }


    static
    size_t[2] opSlice(size_t dim = 0)(size_t i, size_t j) { return [i, j]; }


    inout(T)[] opIndex(size_t[2] ij) inout
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
    }
    do{
        return this.ptr[ij[0] .. ij[1]];
    }


    void opIndexAssign(E)(auto ref const Vec!E rhs)
    if(isAssignable!(T, const(E)))
    in{
        assert(this.length == rhs.length);
    }
    do{
        this.opIndexAssign(rhs, this.opSlice(0, this.length));
    }


    void opIndexAssign(E)(const E[] rhs)
    if(isAssignable!(T, const(E)))
    in{
        assert(this.length == rhs.length);
    }
    do{
        this.opIndexAssign(rhs, this.opSlice(0, this.length));
    }


    void opIndexAssign(E)(auto ref const Vec!E rhs, size_t[2] ij)
    if(isAssignable!(T, const(E)))
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
        assert(ij[1]-ij[0] == rhs.length);
    }
    do{
        this.opIndexAssign(rhs.opIndex(), ij);
    }


    void opIndexAssign(E)(const E[] rhs, size_t[2] ij)
    if(isAssignable!(T, const(E)))
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
        assert(ij[1]-ij[0] == rhs.length);
    }
    do{
      static if(is(E == T))
        this.opIndex(ij)[] = rhs[];
      else
      {
        foreach(i, ref e; this.opIndex(ij)[])
            e = rhs[i];
      }
    }


    void opIndexOpAssign(string op, E)(E v)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    {
        foreach(ref e; this.opIndex())
            mixin("e "~op~"= v;");
    }


    void opIndexOpAssign(string op, E)(const E[] rhs)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    in{
        assert(this.length == rhs.length);
    }
    do{
        foreach(i, ref e; this.opIndex())
            mixin("e "~op~"= rhs[i];");
    }


    void opIndexOpAssign(string op, E)(auto ref const Vec!E rhs)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    in{
        assert(this.length == rhs.length);
    }
    do{
        this.opIndexOpAssign!op(rhs.opIndex());
    }


    void opIndexOpAssign(string op, E)(E v, size_t[2] ij)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
    }
    do{
        foreach(ref e; this.opIndex(ij))
            mixin("e "~op~"= v;");
    }


    void opIndexOpAssign(string op, E)(const E[] rhs, size_t[2] ij)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
        assert(ij[1] - ij[0] == rhs.length);
    }
    do{
        foreach(i, ref e; this.opIndex(ij))
            mixin("e "~op~"= rhs[i];");
    }


    void opIndexOpAssign(string op, E)(auto ref const Vec!E rhs, size_t[2] ij)
    if(is(typeof((T a, E b){ mixin("a "~op~"= b;"); })))
    in{
        assert(ij[1] <= this.length);
        assert(ij[0] <= ij[1]);
        assert(ij[1] - ij[0] == rhs.length);
    }
    do{
        this.opIndexOpAssign!op(rhs.opIndex(ij));
    }


    bool opEquals(E)(auto ref const Vec!E rhs) const
    if(is(typeof((const(T)[] a, const(E)[] b){ bool v = std.algorithm.equal(a, b); })))
    {
        return this.opEquals(rhs.opIndex());
    }


    bool opEquals(E)(const E[] rhs) const
    if(is(typeof((const(T)[] a, const(E)[] b){ bool v = std.algorithm.equal(a, b); })))
    {
        import std.algorithm : equal;
        return equal(this.opIndex(), rhs);
    }


    int opCmp(E)(auto ref const Vec!E rhs) const
    if(is(typeof((const(T)[] a, const(E)[] b){ int v = std.algorithm.cmp(a, b); })))
    {
        return this.opCmp(rhs.opIndex());
    }


    int opCmp(E)(const E[] rhs) const
    if(is(typeof((const(T)[] a, const(E)[] b){ int v = std.algorithm.cmp(a, b); })))
    {
        import std.algorithm : cmp;
        return cmp(this.opIndex(), rhs);
    }


    void opAssign(const T[] rhs)
    {
        this.length = rhs.length;
        this[][] = rhs[];
    }


    void toString(W)(ref W w, const ref FormatSpec!char fmt) const
    if (isOutputRange!(W, char))
    {
        formatValue(w, this[], fmt);
    }


    bool opCast(T : bool)() const
    {
        return this.ptr != null && this.length != 0;
    }


  static if(is(T == Bin))
  {
    itpp.Vec!(itpp.bin) _impl;
  }
  else static if(is(T == Complex!double))
  {
    itpp.Vec!(stdcomplex!double) _impl;
  }
  else
  {
    itpp.Vec!T _impl;
  }

    alias _impl this;
}

//
unittest
{
    Vec!int vec = Vec!int(12);
    assert(vec.length == 12);
    foreach(int i, ref e; vec[]){
        assert(e == 0);
        e = i;
    }

    vec.length = 13;
    foreach(i, ref e; vec[]){
        if(i == 12) assert(e == 0);
        else        assert(e == i);
    }

    vec ~= vec;
    assert(vec.length == 26);
    assert(vec[11] == 11);
    assert(vec[24] == 11);

    vec = vec ~ vec;
    assert(vec.length == 52);
    assert(vec[11] == 11);
    assert(vec[24] == 11);
    assert(vec[37] == 11);
    assert(vec[50] == 11);

    vec.zeros();
    foreach(e; vec[]) assert(e == 0);

    vec.ones();
    foreach(e; vec[]) assert(e == 1);

    vec = Vec!int([1, 2, 3]);

    import std.array;
    auto w = appender!string();
    auto spec = singleSpec("%s");
    vec.toString(w, spec);
    assert(w.data == "[1, 2, 3]");
    assert(vec.to!string == "[1, 2, 3]");

    vec[] += Vec!int([2, 3, 4]);
    assert(vec == [3, 5, 7]);

    vec[] += vec[];
    assert(vec == [6, 10, 14]);
    assert(vec == vec);

    vec[] = [1, 2, 3];
    assert(vec == [1, 2, 3]);

    vec[] *= 2;
    assert(vec == [2, 4, 6]);
}

// Vec!Bin
unittest
{
    auto bins = Vec!Bin(3);
    assert(bins == [0, 0, 0]);

    bins[] = [0, 1, 0];
    assert(bins == [0, 1, 0]);
}

// Vec!(Complex!double)
unittest
{
    import std.math;

    auto cs = Vec!(Complex!double)(3);
    foreach(i, ref e; cs[]){
        assert(e.re.isNaN);
        assert(e.im.isNaN);

        e = Complex!double(i, i*2);
    }

    assert(cs == [Complex!double(0, 0),
                  Complex!double(1, 2),
                  Complex!double(2, 4)]);
}


/**
D言語でのスライスT[]をC++側のVec!Tに変換します．
C++側でdeleteされないようにするため戻り値はconstになっています．
*/
const(Vec!T) toVec(T)(const(T)[] slice) @trusted
{
    Vec!T dst;
    dst._impl.data = cast(T*)slice.ptr;
    dst._impl.datasize = slice.length.to!int;
    dst._impl.factory = null;

    return dst;
}

unittest
{
    const(Vec!int) vec = [1, 2, 3, 4, 5].toVec!int;
    assert(vec.length == 5);
    foreach(i, e; vec[])
        assert(e == i + 1);
}
