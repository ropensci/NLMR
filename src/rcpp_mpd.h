#ifndef RCPP_MPD_H
#define RCPP_MPD_H
#include <Rcpp.h>
#include <random>
//[[Rcpp::plugins("cpp11")]]

void mpd(std::vector<std::vector<double> > &mpd_raster,
         std::vector<double> &rand_dev_vec);

void diamond_step(unsigned side_length, double rand_dev,
                  std::vector<std::vector<double> > &map, std::mt19937 &mt);
void square_step(unsigned side_length, double rand_dev,
                 std::vector<std::vector<double> > &map, std::mt19937 &mt);
double diamond(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length);
double square(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length);
void make_autocorrellation_vec(std::vector<double> &rand_dev_vec,
                                             unsigned size,
                                             double rand_dev,
                                             double roughness);
#endif // RCPP_MPD_H
