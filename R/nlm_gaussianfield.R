#' nlm_gaussianfield
#'
#' @description Simulates a spatially correlated random fields (Gaussian random
#' fields) model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#'  Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#'  Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param autocorr_range [\code{numerical(1)}]\cr
#'  Maximal distance of spatial autocorrelation
#' @param mag_var [\code{numerical(1)}]\cr
#'  Magnitude of variation in the field
#' @param nug [\code{numerical(1)}]\cr
#'  Small-scale variations in the field.
#' @param mean [\code{numerical(1)}]\cr
#'  Mean value over the field.
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set Seed for simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate random gaussian field
#' gaussian_field <- nlm_gaussianfield(ncol = 90, nrow = 90,
#'                                     autocorr_range = 10,
#'                                     mag_var = 3,
#'                                     nug = 0.01)
#'
#' \dontrun{
#' # visualize the NLM
#' util_plot(gaussian_field)
#' }
#'
#' @aliases nlm_gaussianfield
#' @rdname nlm_gaussianfield
#'
#' @export
#'

nlm_gaussianfield <- function(ncol,
                              nrow,
                              resolution = 1,
                              autocorr_range = 10,
                              mag_var = 5,
                              nug = 0.2,
                              mean = 0.5,
                              user_seed = NULL,
                              rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_count(autocorr_range, positive = TRUE)
  checkmate::assert_numeric(mag_var)
  checkmate::assert_numeric(nug)
  checkmate::assert_numeric(mean)
  checkmate::assert_logical(rescale)


  # specify RandomFields options ----
  RandomFields::RFoptions(cPrintlevel = 0)
  RandomFields::RFoptions(spConform = FALSE)

  # set RF seed ----
  if (!is.null(user_seed)) {
    RandomFields::RFoptions(seed = user_seed)
  }

  # formulate gaussian random model
  model <- RandomFields::RMexp(var = mag_var, scale = autocorr_range) +
    RandomFields::RMnugget(var = nug) + # nugget
    RandomFields::RMtrend(mean = mean) # and mean

  # simulate
  simu <-
    RandomFields::RFsimulate(model,
                             x = seq(ncol),
                             y = seq(nrow),
                             grid =  TRUE)

  # coerce to raster
  pred_raster <- raster::raster(simu)
  pred_raster <- pred_raster - raster::cellStats(pred_raster, "min")

  # specify resolution ----
  raster::extent(pred_raster) <- c(0,
                                   ncol(pred_raster) * resolution,
                                   0,
                                   nrow(pred_raster) * resolution)

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    pred_raster <- util_rescale(pred_raster)
  }

  return(pred_raster)
}
