#ifndef RCPP_MPD_H
#define RCPP_MPD_H
#include <Rcpp.h>
#include <random>

void mpd(std::vector<std::vector<double> > &mpd_raster,
         std::vector<double> &rand_dev_vec, unsigned long seed = 0, bool torus = false);

void diamond_step(unsigned side_length, double rand_dev,
                  std::vector<std::vector<double> > &map, std::mt19937 &mt);
void square_step(unsigned side_length, double rand_dev,
                 std::vector<std::vector<double> > &map, std::mt19937 &mt, bool torus);
double diamond(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length);
double square(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length, bool torus = false);
double square_torus(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length);
double square_non_torus(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length);
std::vector<double> make_autocorrellation_vec(std::vector<double> &roughness_vec,
                                             double rand_dev,
                                             unsigned size);
#endif // RCPP_MPD_H
