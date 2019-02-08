#' nlm_gaussianfield
#'
#' @description Simulates a spatially correlated random fields (Gaussian random
#' fields) neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#'  Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#'  Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param autocorr_range [\code{numerical(1)}]\cr
#'  Maximum range (raster units) of spatial autocorrelation.
#' @param mag_var [\code{numerical(1)}]\cr
#'  Magnitude of variation over the entire landscape.
#' @param nug [\code{numerical(1)}]\cr
#'  Magnitude of variation in the scale of \code{autocorr_range},
#'  smaller values lead to more homogeneous landscapes.
#' @param mean [\code{numerical(1)}]\cr
#'  Mean value over the field.
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set random seed for the simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @details
#' Gaussian random fields are a collection of random numbers on a spatially
#' discrete set of coordinates (landscape raster). Natural sciences often apply
#' them with spatial autocorrelation, meaning that objects which distant are more
#' distinct from one another than they are to closer objects.
#'
#' @references
#' Kéry & Royle (2016) \emph{Applied Hierarchical Modeling in Ecology}
#' Chapter 20
#'
#' @examples
#' # simulate random gaussian field
#' gaussian_field <- nlm_gaussianfield(ncol = 90, nrow = 90,
#'                                     autocorr_range = 60,
#'                                     mag_var = 8,
#'                                     nug = 5)
#'
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(gaussian_field)
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
  checkmate::assert_numeric(resolution, lower = 0)
  checkmate::assert_count(autocorr_range, positive = TRUE)
  checkmate::assert_numeric(mag_var, lower = 0)
  checkmate::assert_numeric(nug, lower = 0)
  checkmate::assert_numeric(mean)
  checkmate::assert_logical(rescale)


  # specify RandomFields options ----
  RandomFields::RFoptions(cPrintlevel = 0)
  RandomFields::RFoptions(spConform = FALSE)

  # set RF seed ----
  RandomFields::RFoptions(seed = user_seed)


  # formulate gaussian random model
  model <- RandomFields::RMexp(var = mag_var, scale = autocorr_range) +
    RandomFields::RMnugget(var = nug) + # nugget
    RandomFields::RMtrend(mean = mean) # and mean

  # simulate
  simu <-
    RandomFields::RFsimulate(model,
                             y = seq(ncol),
                             x = seq(nrow),
                             grid =  TRUE)

  # coerce to raster
  pred_raster <- raster::raster(simu)

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
