#' nlm_fbm
#'
#' @description Creates a two-dimensional fractional Brownian motion neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#'  Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#'  Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param fract_dim [\code{numerical(1)}]\cr
#' The fractal dimension of the process (0,2)
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set random seed for the simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#' @param ...
#'  Other options to RandomFields::RFoptions, especially if using
#'  a fractal dimension between ~ 1.6 and 1.9 one must set the option
#'  \code{modus_operandi = "sloppy"}.
#'
#'
#' @details
#' Neutral landscapes are generated using fractional Brownian motion,
#'  an extension of Brownian motion in which the amount of correlation between
#'   steps is controlled by \code{frac_dim}. A high value of \code{frac_dim} produces a
#'    relatively smooth, correlated surface while a low value produces a rough, uncorrelated one.
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate fractional brownian motion
#' fbm_raster  <- nlm_fbm(ncol = 20, nrow = 30, fract_dim = 0.8)
#'
#' \dontrun{
#'
#' # visualize the NLM
#' landscapetools::show_landscape(fbm_raster)
#'
#' }
#'
#' @references
#' Travis, J.M.J. & Dytham, C. (2004). A method for simulating patterns of
#' habitat availability at static and dynamic range margins. \emph{Oikos} , 104, 410–416.
#'
#' Martin Schlather, Alexander Malinowski, Peter J. Menck, Marco Oesting,
#' Kirstin Strokorb (2015). nlm_fBm. \emph{Journal of Statistical
#' Software}, 63(8), 1-25. URL http://www.jstatsoft.org/v63/i08/.
#'
#' @aliases nlm_fbm
#' @rdname nlm_fbm
#'
#' @export
#'

nlm_fbm <- function(ncol,
                    nrow,
                    resolution = 1,
                    fract_dim = 1,
                    user_seed = NULL,
                    rescale = TRUE,
                    ...) {
  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(fract_dim)
  checkmate::assert_true(fract_dim > 0)
  checkmate::assert_true(fract_dim <= 2)
  checkmate::assert_logical(rescale)

  # specify RandomFields options ----
  RandomFields::RFoptions(cPrintlevel = 0)
  RandomFields::RFoptions(spConform = FALSE)
  RandomFields::RFoptions(...)

  # set RF seed ----
  RandomFields::RFoptions(seed = user_seed)

  # formulate and simulate fBm model
  fbm_model <- RandomFields::RMfbm(
    alpha = fract_dim)
  fbm_simu <- RandomFields::RFsimulate(fbm_model,
                                       # fBm changes x and y?
                                       y = seq.int(0, length.out = ncol),
                                       x = seq.int(0, length.out = nrow),
                                       grid = TRUE)


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
