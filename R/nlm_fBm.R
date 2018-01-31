#' nlm_fBm
#'
#' @description Simulates two-dimensional fractional brownian motion model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#'  Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#'  Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param fract_dim [\code{numerical(1)}]\cr
#'  numeric in (0,2]; refers to the fractal dimension of the process
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set Seed for simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @details
#' Neutral landscapes are generated using fractional Brownian motion,
#'  an extension of Brownian motion in which the amount of correlation between
#'   steps is controlled by the Hurst coefficient H. An H of 1 produces a
#'    relatively smooth surface while an H of 0 produces a rough, uncorrelated,
#'     surface. Implementation of this method is limited to landscapes with
#'      extents less than 90 by 90 cells.
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate fractional brownian motion
#' (fBm_raster  <- nlm_fBm(ncol = 20, nrow = 30, fract_dim = 0.8))
#' \dontrun{
#' # visualize the NLM
#' util_plot(fBm_raster)
#' }
#' @references
#' Martin Schlather, Alexander Malinowski, Peter J. Menck, Marco Oesting,
#' Kirstin Strokorb (2015). Analysis, Simulation and Prediction of Multivariate
#' Random Fields with Package RandomFields. \emph{Journal of Statistical
#' Software}, 63(8), 1-25. URL http://www.jstatsoft.org/v63/i08/.
#'
#' @aliases nlm_fBm
#' @rdname nlm_fBm
#' @include util_rescale.R
#'
#' @export
#'

nlm_fBm <- function(ncol,
                    nrow,
                    resolution = 1,
                    fract_dim = 1,
                    user_seed = NULL,
                    rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(fract_dim)
  checkmate::assert_true(fract_dim < 2)
  checkmate::assert_logical(rescale)

  # specify RandomFields options ----
  RandomFields::RFoptions(cPrintlevel = 0)
  RandomFields::RFoptions(spConform = FALSE)

  # set RF seed ----
  if (!is.null(user_seed)) {
    RandomFields::RFoptions(seed = user_seed)
  }

  # formulate and simulate fBm model
  fbm_model <- RandomFields::RMfbm(
    alpha = fract_dim)
  fbm_simu <- RandomFields::RFsimulate(fbm_model,
                                       # fBm changes x and y?
                                       y = seq(ncol),
                                       x = seq(nrow),
                                       grid =  TRUE)


  # transform simulation into raster ----
  fbm_raster <- raster::raster(fbm_simu)


  # specify extent and resolution ----
  raster::extent(fbm_raster) <- c(
    0,
    ncol(fbm_raster) * resolution,
    0,
    nrow(fbm_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    fbm_raster <- util_rescale(fbm_raster)
  }

  return(fbm_raster)
}
