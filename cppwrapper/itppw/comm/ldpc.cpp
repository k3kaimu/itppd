#include <string>
#include <itpp/comm/ldpc.h>


using namespace itpp;

namespace itppw
{


LDPC_Parity_Regular *new_LDPC_Parity_Regular()
{
    return new LDPC_Parity_Regular;
}


LDPC_Generator_Systematic *new_LDPC_Generator_Systematic(
    LDPC_Parity * H,
    bool natural_ordering,
    const ivec& ind
)
{
    return new LDPC_Generator_Systematic(H, natural_ordering, ind);
}


LDPC_Code *new_LDPC_Code(
    const LDPC_Parity * const H,
    LDPC_Generator * G,
    bool perform_integrity_check
)
{
    return new LDPC_Code(H, G, perform_integrity_check);
}




}