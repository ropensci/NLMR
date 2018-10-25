#ifndef RCPP_NEIGH_H
#define RCPP_NEIGH_H
#include <Rcpp.h>
//Rcpp::NumericMatrix rcpp_which(const Rcpp::NumericMatrix& X, int what);
std::vector<std::pair<int, int> > random_cell_indecies(int ncol, int nrow, int offset = 0);
inline int randWrapper( const int n ) { return floor(unif_rand()*n); };
#endif // RCPP_NEIGH_H
