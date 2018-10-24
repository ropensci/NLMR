#include <Rcpp.h>

using namespace Rcpp;
using namespace std;

NumericMatrix rcpp_which(const NumericMatrix& X, int what) {

  int n_rows = X.nrow();

  NumericVector rows(0);
  NumericVector cols(0);

  for(int ii = 0; ii < n_rows * n_rows; ii++)
  {
    if(X[ii] == what)
    {
      rows.push_back(ii % n_rows); // rows.push_back(ii % n_rows + 1);
      cols.push_back(floor(ii / n_rows)); // cols.push_back(floor(ii / n_rows) + 1);
    }
  }
  NumericMatrix out (rows.size(), 2);
  out(_,0) = rows; out(_,1)=cols;
  return out;

}

// [[Rcpp::export]]
NumericMatrix rcpp_neigh(int nrow,
                         int ncol,
                         NumericMatrix mat,
                         int cat,
                         NumericVector no_cat,
                         int neighbourhood,
                         float p_neigh,
                         float p_empty) {

  while (cat >= 0) {

    int j = 0;

    int ncat = no_cat(cat);
    // Rcout << "The value of ncat : " << ncat << "\n";
    while (j < ncat) {

      NumericMatrix s;

      s = rcpp_which(mat(Range(1, nrow), Range(1, ncol)), 0);

      int row_pos = as<int>(Rcpp::sample(s.nrow(), 1));
      int row = s(row_pos, 0) + 1;
      int col = s(row_pos, 1) + 1;

      double adjacent;

      double up_cell = mat(row - 1, col);
      double left_cell = mat(row, col - 1);
      double right_cell = mat(row, col + 1);
      double low_cell = mat(row + 1, col);

      if (neighbourhood == 8) {

        int upleft_cell = mat(row - 1, col - 1);
        int upright_cell = mat(row - 1, col + 1);
        int lowleft_cell = mat(row + 1, col - 1);
        int lowright_cell = mat(row + 1, col + 1);

        adjacent = sum(NumericVector::create(up_cell,
                                             left_cell,
                                             right_cell,
                                             low_cell,
                                             upleft_cell,
                                             upright_cell,
                                             lowleft_cell,
                                             lowright_cell));
      } else {

        adjacent = sum(NumericVector::create(up_cell,
                                             left_cell,
                                             right_cell,
                                             low_cell));
      }

      if (adjacent > 0){

        float rnd_num = as<float>(runif(1, 0, 1));
        if (rnd_num < p_neigh) {
          mat(row, col) = cat;
          // Rcout << "The value of mat(row, col) : " << mat(row, col) << "\n";
          j++;
        }

      } else {

        float rnd_num = as<float>(runif(1, 0, 1));

        if (rnd_num < p_empty) {
          mat(row, col) = cat;
          // Rcout << "The value of mat(row, col) : " << mat(row, col) << "\n";
          j++;
        }

      }
      // Rcout << "The value of j : " << j << "\n";
      // mat(0, _)         = mat(nrow, _);
      // mat(nrow + 1, _)  = mat(1, _);
      // mat(_, 0)         = mat(_, ncol);
      // mat(_, ncol + 1)  = mat(_,1);

    } // close while j
    cat = cat - 1;
  }// close while i
  return mat;
}

/*** R
categories = 3
cat = categories - 1
ncol = 50
nrow = 50
p_neigh = 0.3
p_empty = 0.03
neighbourhood = 4
mat <- matrix(0, nrow + 2, ncol + 2)
no_cat <- rep(floor(nrow * ncol / categories), categories)
table(rcpp_neigh(nrow, ncol, mat, cat, no_cat, neighbourhood, p_neigh, p_empty))
*/

