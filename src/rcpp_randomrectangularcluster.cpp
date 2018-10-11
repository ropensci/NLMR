#include <Rcpp.h>
using namespace Rcpp;

#include <algorithm>    // std::any_of
#include <random> // mersenne twister


// [[Rcpp::plugins("cpp11")]]

// Helper functions
inline bool is_still_na(NumericMatrix matrix);
inline int mod(int divident, int divisor); // R-style molulo


//' @export
// [[Rcpp::export]]
NumericMatrix rcpp_randomrectangularcluster(int ncol, int nrow, int minl, int maxl) {

  std::uniform_int_distribution<int> random_size(minl, maxl);
  std::uniform_int_distribution<int> random_row_pos(0, nrow - 1);
  std::uniform_int_distribution<int> random_col_pos(0, ncol - 1);
  std::uniform_real_distribution<double> random_land_use(0, 1);
  std::mt19937 mt;

  double NA = -1.0;
  NumericMatrix matrix(nrow, ncol);
  std::fill(matrix.begin(), matrix.end(), NA);

  while (is_still_na(matrix)) {

    int row_pos = random_row_pos(mt);
    int col_pos = random_col_pos(mt);
    int width = random_size(mt) + row_pos;
    int height = random_size(mt) + col_pos;
    double land_use = random_land_use(mt);

    for (int row = row_pos; row < width; row++) {
      int row_ = mod(row, nrow);
      for (int col = col_pos; col < height; col++) {
        int col_ = mod(col, ncol);
        matrix(row_, col_) = land_use;
      }
    }

  }
  return (matrix);
}

inline bool is_still_na(NumericMatrix matrix) {
  bool still_na = false;
  still_na = std::any_of(matrix.begin(), matrix.end(), [](double i){return i == -1.0;});
  if (still_na) {
    return(still_na);
  }
  return(false);
}

// from Armen Tsirunyan @ http://stackoverflow.com/questions/4003232/how-to-code-a-modulo-operator-in-c-c-obj-c-that-handles-negative-numbers
inline int mod (int divident, int divisor)
{
  int ret = divident % divisor;
  if(ret < 0)
    ret += divisor;
  return ret;
}
