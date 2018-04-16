module itppd.comm.ldpc;


enum ITPP_COMM_LDPC =
q{
    interface Channel_Code {}

    interface LDPC_Parity {}
    interface LDPC_Parity_Unstructed : LDPC_Parity {}
    interface LDPC_Parity_Irregular : LDPC_Parity_Unstructed {}
    interface LDPC_Parity_Regular : LDPC_Parity_Unstructed {}
    interface BLDPC_Parity : LDPC_Parity {}
    interface LDPC_Generator {}
    interface LDPC_Generator_Systematic : LDPC_Generator {}
    interface BLDPC_Generator : LDPC_Generator {}
    interface LDPC_Code : Channel_Code {}
};


enum ITPP_COMM_LDPC_W =
q{
    LDPC_Parity_Regular new_LDPC_Parity_Regular();

    LDPC_Generator_Systematic *new_LDPC_Generator_Systematic(
        LDPC_Parity H,
        bool natural_ordering,
        ref const itpp.Vec!int ind
    );

    LDPC_Code new_LDPC_Code(
        const LDPC_Parity H,
        LDPC_Generator G,
        bool perform_integrity_check
        );
};


unittest
{
    import itppd.wrapper;

    auto H = new_LDPC_Parity_Regular();
    assert(H !is null);
}
