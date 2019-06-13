#ifndef RCPP_HELPER_FUNCTIONS_H
#define RCPP_HELPER_FUNCTIONS_H
#include <Rcpp.h>

//[[Rcpp::plugins("cpp11")]]

inline bool is_still_na(Rcpp::NumericMatrix matrix) {
  bool still_na = false;
  still_na = std::any_of(matrix.begin(), matrix.end(), [](double i){return i == -1.0;});
  if (still_na) {
    return(still_na);
  }
  return(false);
}

// from Armen Tsirunyan @ http://stackoverflow.com/questions/4003232/how-to-code-a-modulo-operator-in-c-c-obj-c-that-handles-negative-numbers
inline unsigned mod(int divident, int divisor)
{
  int ret = divident % divisor;
  if(ret < 0)
    ret += divisor;
  return(static_cast<unsigned>(ret));
}

#endif // RCPP_HELPER_FUNCTIONS_H
