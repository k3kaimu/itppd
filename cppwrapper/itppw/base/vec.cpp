#include <itpp/base/vec.h>

namespace itppw
{

void dtor_Vec(itpp::Vec<int>& vec) { vec.~Vec(); }
void dtor_Vec(itpp::Vec<short int>& vec) { vec.~Vec(); }
void dtor_Vec(itpp::Vec<double>& vec) { vec.~Vec(); }
void dtor_Vec(itpp::Vec<std::complex<double> >& vec) { vec.~Vec(); }
void dtor_Vec(itpp::Vec<itpp::bin>& vec) { vec.~Vec(); }

}