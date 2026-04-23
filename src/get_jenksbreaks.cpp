// C++ code to calculate Jenks natural breaks
// Ported from R package seqInt by Pascal Title, January 2015
// Re-implemented from get_jenkbreaks.c using Rcpp, April 2026

#include <Rcpp.h>
#include <limits>

// [[Rcpp::export]]
Rcpp::NumericVector rcpp_get_jenksbreaks(const Rcpp::NumericVector& d, int k) {
  const int length_d = d.size();
  if (length_d == 0) {
    return Rcpp::NumericVector();
  }

  const int nCat = k;

  std::vector<std::vector<double>> mat1(
    length_d, std::vector<double>(k, 1.0)
  );
  std::vector<std::vector<double>> mat2(
    length_d, std::vector<double>(k, 0.0)
  );

  const double max_double = std::numeric_limits<double>::max();

  for (int i = 1; i < length_d; i++) {
    for (int j = 0; j < k; j++) {
      mat2[i][j] = max_double;
    }
  }

  double v = 0.0;

  for (int l = 2; l <= length_d; l++) {
    double s1 = 0.0;
    double s2 = 0.0;
    double w = 0.0;

    for (int m = 1; m <= l; m++) {
      const int i3 = l - m + 1;
      const double val = d[i3 - 1];
      s2 += val * val;
      s1 += val;
      w += 1.0;
      v = s2 - (s1 * s1) / w;
      const int i4 = i3 - 1;

      if (i4 != 0) {
        for (int j = 2; j <= k; j++) {
          if (mat2[l - 1][j - 1] >= (v + mat2[i4 - 1][j - 2])) {
            mat1[l - 1][j - 1] = i3;
            mat2[l - 1][j - 1] = v + mat2[i4 - 1][j - 2];
          }
        }
      }
    }
    mat1[l - 1][0] = 1.0;
    mat2[l - 1][0] = v;
  }

  std::vector<int> kclass(k);
  for (int i = 1; i <= k; i++) {
    kclass[i - 1] = i;
  }

  kclass[k - 1] = length_d;
  int k_temp = length_d;

  for (int j = nCat; j > 1; j--) {
    const int id = static_cast<int>(mat1[k_temp - 1][j - 1]) - 1;
    kclass[j - 2] = id;
    k_temp = id;
  }

  Rcpp::NumericVector brks(nCat + 1);
  brks[0] = d[0];
  for (int i = 1; i < (nCat + 1); i++) {
    brks[i] = d[kclass[i - 1] - 1];
  }

  return brks;
}
