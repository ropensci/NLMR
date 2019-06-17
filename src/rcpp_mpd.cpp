#include "rcpp_mpd.h"
#include <math.h> // log
#include <limits>
#include "rcpp_helper_functions.h"


//[[Rcpp::plugins("cpp11")]]

// [[Rcpp::export]]
Rcpp::NumericMatrix rcpp_mpd(unsigned ncol, 
                             unsigned nrow,
                             double rand_dev,
                             Rcpp::NumericVector rcpp_roughness,
                             unsigned long seed,
                             bool torus) {

    // setup matrix ----
    // (width and height must be an odd number)
    unsigned mpd_raster_size = std::max(nrow, ncol);
    if (mpd_raster_size % 2 == 0) {
        mpd_raster_size++;
    }
    std::vector<std::vector<double> > mpd_raster(mpd_raster_size);
    for (auto &v : mpd_raster) {
        v.assign(mpd_raster_size, 0.0);
    }

    // setup random decay (and hence spatial autocorrelation) ----
    unsigned n_steps = static_cast<unsigned>(std::ceil(std::log2(mpd_raster_size - 1)));
    std::vector<double> roughness_vec(rcpp_roughness.begin(), rcpp_roughness.end());
    std::vector<double> rand_dev_vec = make_autocorrellation_vec(roughness_vec, rand_dev, n_steps);

    // get a random number as seed from R
    // the landscape generator ----
    mpd(mpd_raster, rand_dev_vec, seed, torus);

    // prepare everything for R ----
    Rcpp::NumericMatrix rcpp_mpd_raster(mpd_raster_size, mpd_raster_size);
    for (unsigned col = 0; col < mpd_raster_size; col++) {
        for (unsigned row = 0; row < mpd_raster_size; row++) {
            rcpp_mpd_raster(col, row) = mpd_raster[col][row];
        }
    }

    return rcpp_mpd_raster;
}

void mpd(std::vector<std::vector<double> > &mpd_raster,
         std::vector<double> &rand_dev_vec, unsigned long seed, bool torus)
{
    std::mt19937 mt;
    mt.seed(seed);
    std::uniform_real_distribution<double> runif(0, 1);
    auto matrix_size = mpd_raster.size();
    unsigned n_steps = static_cast<unsigned>(std::ceil(std::log2(matrix_size - 1)));

    std::vector<unsigned> side_length_vector(n_steps);
    for (unsigned n = n_steps; n > 0; n--) {
        side_length_vector[n_steps - n] = std::pow(2, n);
    }

    assert(side_length_vector.size() == rand_dev_vec.size());

    // seed the four corners
    mpd_raster[0][0] = runif(mt);
    mpd_raster[0][matrix_size - 1] = runif(mt);
    mpd_raster[matrix_size - 1][0] = runif(mt);
    mpd_raster[matrix_size - 1][matrix_size - 1] = runif(mt);

    for (unsigned step = 0; step < side_length_vector.size(); step++) {
        double rand_dev = rand_dev_vec[step];
        unsigned side_length = side_length_vector[step];

        diamond_step(side_length, rand_dev, mpd_raster, mt);
        square_step(side_length, rand_dev, mpd_raster, mt, torus);
    }

}


void diamond_step(unsigned side_length, double rand_dev,
                  std::vector<std::vector<double> > &map,
                  std::mt19937 &mt) {

    assert(side_length % 2 == 0);
    unsigned half_length = side_length / 2;
    unsigned matrix_size = map.size(); // map is a square

    for (unsigned col = half_length; col < matrix_size; col += side_length) {
        for (unsigned row = half_length; row < matrix_size; row += side_length){
            std::normal_distribution<double> rnorm(0, rand_dev);
            map[col][row] = diamond(map, col, row, half_length) + rnorm(mt);
        }
    }
}

void square_step(unsigned side_length, double rand_dev,
                 std::vector<std::vector<double> > &map,
                 std::mt19937 &mt, bool torus) {
    auto matrix_size = map.size(); // map is a square
    unsigned half_length = side_length / 2;

    unsigned step = 0;
    for (unsigned col = 0; col < matrix_size; col += half_length) {
        unsigned row_start = 0;

        if (step % 2 == 0) {
            row_start = half_length;
        }
        step++;

        for (unsigned row = row_start; row < matrix_size; row += side_length) {
            std::normal_distribution<double> rnorm(0, rand_dev);
            map[col][row] = square(map, col, row, half_length, torus) + rnorm(mt);
        }
    }
}


double diamond(const std::vector<std::vector<double> > &map,
               unsigned col, unsigned row, unsigned half_length) {
    int coordinate[4][2] = {{0, 0},{0, 0},{0, 0},{0, 0}};
    int matrix_size = map.size(); // map is a square
    double a = map[col][row];
    double b = map[col][row];
    double c = map[col][row];
    double d = map[col][row];


    coordinate[0][0] = col - half_length;
    coordinate[0][1] = row - half_length;
    if (coordinate[0][0] >= 0 && coordinate[0][1] >= 0) {
        a = map[coordinate[0][0]][coordinate[0][1]];
    }

    coordinate[1][0] = col - half_length;
    coordinate[1][1] = row + half_length;
    if (coordinate[1][0] >= 0 && coordinate[1][1] < matrix_size) {
        b = map[coordinate[1][0]][coordinate[1][1]];
    }

    coordinate[2][0] = col + half_length;
    coordinate[2][1] = row - half_length;
    if (coordinate[2][0] < matrix_size && coordinate[2][1] >= 0) {
        c = map[coordinate[2][0]][coordinate[2][1]];
    }

    coordinate[3][0] = col + half_length;
    coordinate[3][1] = row + half_length;
    if (coordinate[3][0] < matrix_size && coordinate[3][1] < matrix_size) {
        d = map[coordinate[3][0]][coordinate[3][1]];
    }

    return (0.25 * (a + b + c + d));
}

double square_non_torus(const std::vector<std::vector<double> > &map,
                        unsigned col, unsigned row, unsigned half_length) {
    int coordinate[4][2] = {{0, 0},{0, 0},{0, 0},{0, 0}};
    unsigned matrix_size = map.size(); // map is a square
    double a = map[col][row];
    double b = map[col][row];
    double c = map[col][row];
    double d = map[col][row];

    coordinate[0][0] = col - half_length;
    coordinate[0][1] = row;
    if (coordinate[0][0] >= 0) {
        a = map[coordinate[0][0]][coordinate[0][1]];
    }

    coordinate[1][0] = col;
    coordinate[1][1] = row + half_length;
    if (coordinate[1][1] < matrix_size) {
        b = map[coordinate[1][0]][coordinate[1][1]];
    }

    coordinate[2][0] = col + half_length;
    coordinate[2][1] = row;
    if (coordinate[2][0] < matrix_size) {
        c = map[coordinate[2][0]][coordinate[2][1]];
    }

    coordinate[3][0] = col;
    coordinate[3][1] = row - half_length;
    if (coordinate[3][1] >= 0) {
        d = map[coordinate[3][0]][coordinate[3][1]];
    }

    return (0.25 * (a + b + c + d));
}

double square_torus(const std::vector<std::vector<double> > &map,
                    unsigned col, unsigned row, unsigned half_length) {
    unsigned coordinate[4][2] = {{0, 0},{0, 0},{0, 0},{0, 0}};
    unsigned matrix_size = map.size(); // map is always a square!
    double a = map[col][row];
    double b = map[col][row];
    double c = map[col][row];
    double d = map[col][row];

    coordinate[0][0] = mod(col - half_length, matrix_size);
    coordinate[0][1] = row;
    a = map[coordinate[0][0]][coordinate[0][1]];

    coordinate[1][0] = col;
    coordinate[1][1] = mod(row + half_length, matrix_size);
    b = map[coordinate[1][0]][coordinate[1][1]];

    coordinate[2][0] = mod(col + half_length, matrix_size);
    coordinate[2][1] = row;
    c = map[coordinate[2][0]][coordinate[2][1]];

    coordinate[3][0] = col;
    coordinate[3][1] = mod(row - half_length, matrix_size);
    d = map[coordinate[3][0]][coordinate[3][1]];

    return (0.25 * (a + b + c + d));
}

std::vector<double> make_autocorrellation_vec(std::vector<double> &roughness_vec,
                                              double rand_dev,
                                              unsigned size)
{
    std::vector<double> rand_dev_vec(size);
    if(roughness_vec.size() == 1) {
        rand_dev_vec[0] = rand_dev;
        for (int i = 1; i < size; i++) {
            rand_dev_vec[i] = rand_dev_vec[i - 1] * roughness_vec[0];
        }
    } else {
        for (int i = 0; i < size; i++) {
            rand_dev_vec[i] = roughness_vec[i] * rand_dev;
        }
    }
    return rand_dev_vec;
}

double square(const std::vector<std::vector<double> > &map, unsigned col,
              unsigned row, unsigned half_length, bool torus)
{
    double result = 0;

    if (torus) {
        result = square_torus(map, col, row, half_length);
    } else
        result = square_non_torus(map, col, row, half_length);

    return result;
}
