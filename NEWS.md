## NLMR 1.3.0.9000 (WIP)

<!-- - Update `nlm_fbm()` to use a new post-`RandomFields` approximation for fractional Brownian landscapes. The current implementation generates an isotropic frequency-based surface for `fract_dim < 2`, then recentres and rescales it based on one-cell differences, while the endpoint `fract_dim = 2` is treated as the smooth linear limit.
- Update `nlm_gaussianfield()` to use a new post-`RandomFields` approximation based on an exponential covariance surface, with optional nugget noise and a user-defined mean added afterward. In practice, this means that `autocorr_range` now acts more directly on the spatial structure of the landscape, `mag_var` controls the variance of the correlated component, and `nug` adds fine-scale local variation on top of that broader pattern. -->

## NLMR 1.2.0

- Replace deprecated std::random_shuffle with std::shuffle in C++ code.
- Cleans vignettes
- Disables nlm_fbm and nlm_gaussianfield functions for now, until they can be reimplemented with the new approach, eliminating the need for RandomFields

## NLMR 1.1.1 Release Notes

- Adding onload function and help for users that dont have `RandomFields`

## NLMR 1.1.0.9000 Release Notes

- move `RandomFields` and `RandomFieldsUtils` to Suggests and use AdditionalRepositories to provide these packages since they are no longer available from CRAN (with #95)

## NLMR 0.4.2 Release Notes

- Bugfix in nlm_mosaicfield to rely on new version of RandomFields

## NLMR 0.4.1 Release Notes

- Bugfix in nlm_mpd to not rely on landscapetools

## NLMR 0.4 Release Notes

- nlm_neigh, nlm_mpd and nlm_randomrectangularcluster are now implemented in Rcpp
- all of the Rcpp also take the R random seed
- Minor bug fixes
- Improvements to documentation
- More examples on the package website

## NLMR 0.3.2 Release Notes

- Update citation 

## NLMR 0.3.1 Release Notes

- Minor bug fixes
- Updated documentation
- removed purrr as dependency

## NLMR 0.3.0 Release Notes

- successful review through rOpenSci
- split package into two packages:
  - `NLMR` 
    - contains now only the neutral landscape models, minimal dependencies
  - [`landscapetools`](https://github.com/ropensci/landscapetools)
    - contains now only utility functions
- small bug fixes
- `nlm_fBm` is now `nlm_fbm`

## NLMR 0.2.1 Release Notes

- Skip one test on CRAN to keep the Roboto font available
- Function `show_landscape` to plot a list of rasters as ggplot2 facet
- Small updates to the webpage

## NLMR 0.2 Release Notes

- Small bug fixes
- New neutral landscape models
    - `nlm_wheys`: Simulates a wheyed neutral landscape model
- Parameter `p` in `nlm_curds` now controls the proportion of habitat instead of 
  the amount of matrix
- Implemented new theme `theme_nlm`
- Functions to coerce raster to tibbles and vice versa (for facetting with `ggplot2`)
- We now have unit tests covering the main functionality of the package
- Removed several packages as dependencies 

## NLMR 0.1.0 Release Notes

v0.1.0 was released on 30/11/2017

- First stable release of NLMR
