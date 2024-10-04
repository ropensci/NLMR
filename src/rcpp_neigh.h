#ifndef RCPP_NEIGH_H
#define RCPP_NEIGH_H
#include <Rcpp.h>
#include <random>
using namespace Rcpp;

// [[Rcpp::export]]
IntegerMatrix rcpp_neigh(int nrow,
                         int ncol,
                         IntegerMatrix mat,
                         int n_categories,
                         IntegerVector cells_per_cat,
                         int neighbourhood,
                         float p_neigh,
                         float p_empty,
                         unsigned long seed);

static std::uniform_real_distribution<double> random_unif(0, 1);
static std::mt19937 mt;

std::vector<std::pair<int, int> > random_cell_indices(int ncol, int nrow, int offset = 0);
inline int randWrapper(const int n) { return floor(random_unif(mt) * n); };
#endif // RCPP_NEIGH_H
