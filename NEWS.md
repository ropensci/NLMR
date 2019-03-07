____________________________________________________________________________________
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
  - [`landscapetools`](https://github.com/marcosci/landscapetools)
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
