#include <Rcpp.h>
using namespace Rcpp;

#include <algorithm>    // std::any_of
#include <random> // mersenne twister
#include "rcpp_helper_functions.h"


//[[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
NumericMatrix rcpp_randomrectangularcluster(int ncol, int nrow, int minl, int maxl, unsigned long seed) {

    std::uniform_int_distribution<int> random_size(minl, maxl);
    std::uniform_int_distribution<int> random_row_pos(0, nrow - 1);
    std::uniform_int_distribution<int> random_col_pos(0, ncol - 1);
    std::uniform_real_distribution<double> random_land_use(0, 1);
    std::mt19937 mt;
    mt.seed(seed);

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
            unsigned row_ = mod(row, nrow);
            for (int col = col_pos; col < height; col++) {
                unsigned col_ = mod(col, ncol);
                matrix(row_, col_) = land_use;
            }
        }

    }
    return matrix;
}

