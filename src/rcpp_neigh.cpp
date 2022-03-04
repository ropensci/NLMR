#include "rcpp_neigh.h"
#include "rcpp_helper_functions.h"
using namespace std;
#include <random> // mersenne twister
#include <iostream>

IntegerMatrix rcpp_neigh(int nrow,
                         int ncol,
                         IntegerMatrix mat,
                         int n_categories,
                         IntegerVector cells_per_cat,
                         int neighbourhood,
                         float p_neigh,
                         float p_empty,
                         unsigned long seed) {

    // get a random number as seed from R
    mt.seed(seed);
    std::vector<std::pair<int, int> > cell_index =
            random_cell_indices(ncol, nrow);

    for (int cat = n_categories; cat >= 0; cat--)
    {
        int n_cells = cells_per_cat(cat);

        while (n_cells > 0) {
            const int col = cell_index.back().first;
            const int row = cell_index.back().second;

            const unsigned up = mod(row - 1, nrow);
            const unsigned left = mod(col - 1, ncol);
            const unsigned right = mod(col + 1, ncol);
            const unsigned down = mod(row + 1, nrow);

            const unsigned up_cell = mat(up, col);
            const unsigned left_cell = mat(row, left);
            const unsigned right_cell = mat(row, right);
            const unsigned low_cell = mat(down, col);

            unsigned adjacent = up_cell + left_cell + right_cell + low_cell;
            if (adjacent == 0) {
                if (neighbourhood == 8) {
                    const unsigned upleft_cell = mat(up, left);
                    const unsigned upright_cell = mat(up, right);
                    const unsigned lowleft_cell = mat(down, left);
                    const unsigned lowright_cell = mat(down, right);
                    adjacent += upleft_cell + upright_cell + lowleft_cell + lowright_cell;
                }
            }

            const double prob = adjacent > 0 ? p_neigh : p_empty;
            const double rnd_num = random_unif(mt);

            if (rnd_num < prob) {
                mat(row, col) = cat;
                n_cells--;
                cell_index.pop_back();
            } else {
                const unsigned back = cell_index.size() - 1;
                const unsigned idx = randWrapper(back);
                const auto tmp = cell_index[idx];
                cell_index[idx] = cell_index[back];
                cell_index[back] = tmp;
            }
        }
    }

    return mat;
}

std::vector<std::pair<int, int> > random_cell_indices(int ncol, int nrow, int offset)
{
    std::vector<std::pair<int, int> > cell_index(nrow * ncol);
    int cntr = 0;
    for (int col = 0; col < ncol; col++) {
        for (int row = 0; row < nrow; row++) {
            cell_index[cntr].first = col + offset;
            cell_index[cntr].second = row + offset;
            cntr++;
        }
    }

    std::random_shuffle(cell_index.begin(), cell_index.end(), randWrapper);

    return cell_index;
}


/*** R
categories = 15
cat = categories - 1
ncol = 300
nrow = 300
p_neigh = 0.6
p_empty = 0.2
neighbourhood = 4
mat <- matrix(0, nrow + 2, ncol + 2)
no_cat <- rep(floor(nrow * ncol / categories), categories)
table(rcpp_neigh(nrow, ncol, mat, cat, no_cat, neighbourhood, p_neigh, p_empty))
*/

