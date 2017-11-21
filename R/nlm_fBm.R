#' nlm_fBM
#'
#' Simulate two-dimensional fractional brownian motion model.
#'
#' @param nCol [\code{numerical(1)}]\cr
#'  Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#'  Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param H [\code{numerical(1)}]\cr
#'  Hurst coefficient
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set Seed for simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @details
#' Neutral landscapes are generated using fractional Brownian motion, an extension of Brownian motion in which the amount of correlation between steps is controlled by the Hurst coefficient H. An H of 1 produces a relatively smooth surface while an H of 0 produces a rough, uncorrelated, surface. Implementation of this method is limited to landscapes with extents less than 90 by 90 cells.
#'
#' @return RasterLayer
#'
#' @examples
#' nlm_fBm(nCol = 40, nRow = 40, H = 0.5)
#'
#' @aliases nlm_fBm
#' @rdname nlm_fBm
#'
#' @export
#'

nlm_fBm <- function(nCol,
                    nRow,
                    resolution = 1,
                    H = 0.5,
                    user_seed = NULL,
                    rescale = TRUE){

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(H)
  checkmate::assert_true(H <= 1)
  checkmate::assert_logical(rescale)

  # specify RandomFields options ----
  RandomFields::RFoptions(cPrintlevel=0)
  RandomFields::RFoptions(spConform=FALSE)

  # set RF seed ----
  if(!is.null(user_seed)){
    RandomFields::RFoptions(seed=user_seed)
  }

  # specify spatial extent for simulation ----
  x <- seq(0,1, len=nCol)
  y <- seq(0,1, len=nRow)

  # formulate and simulate fBm model
  fBm_model <- RandomFields::RMgenfbm(alpha=H * 2,
                                      beta=0.5)
  fBm_simu  <- RandomFields::RFsimulate(fBm_model, x, y)


  # transform simulation into raster ----
  fbm_raster <- raster::raster(fBm_simu)


  # specify extent and resolution ----
  raster::extent(fbm_raster) <- c(0,
                                  ncol(fbm_raster)*resolution,
                                  0,
                                  nrow(fbm_raster)*resolution)

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    fbm_raster <- util_rescale(fbm_raster)
  }

  return(fbm_raster)

}
