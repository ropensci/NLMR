#ifndef RCPP_NEIGH_H
#define RCPP_NEIGH_H
#include <Rcpp.h>
#include <random>

static std::uniform_real_distribution<double> random_unif(0, 1);
static std::mt19937 mt;

std::vector<std::pair<int, int> > random_cell_indecies(int ncol, int nrow, int offset = 0);
inline int randWrapper( const int n ) {
    return floor(random_unif(mt) * n); };
#endif // RCPP_NEIGH_H
