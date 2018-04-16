module itppd.base.wrapper;


extern(C++, std)
{
    struct complex(T)
    {
        T re;
        T im;
    }
}

alias stdcomplex = complex;


extern(C++, itpp)
{
    class Factory {}

    struct bin
    {
        char b;
    }

    struct Vec(T)
    {
        alias value_type = T;

        int length() const;
        int set_length(int size, bool copy = false);
        void zeros();
        void clear();
        void ones();
        void set(const(char)* str);
        ref const(T) get(int i) const;
        Vec!T get(int i2, int i2) const;
        void set(int i, T v);

      package:
        int datasize;
        T* data;
        Factory* factory;
    }
}

alias itppbin = bin;
alias itppvec = Vec;
