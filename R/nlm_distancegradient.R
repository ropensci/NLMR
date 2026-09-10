#' nlm_distancegradient
#'
#' @description Simulates a distance-gradient neutral landscape model.
#'
#' @details
#' The function takes the number of columns and rows as input and creates a
#' \code{RasterLayer} with the same extent. \code{Origin} is a numeric vector of
#' xmin, xmax, ymin, ymax for a rectangle inside the raster from which the
#' distance is measured.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param origin  [\code{numerical(4)}]\cr
#' Edge coordinates of the origin (raster::extent with xmin, xmax, ymin, ymax)
#' of the distance measurement.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#' Otherwise, the distance in raster units is calculated.
#'
#' @return SpatRaster
#'
#' @examples
#'
#' # simulate a distance gradient
#' distance_gradient <- nlm_distancegradient(ncol = 100, nrow = 100,
#'                                            origin = c(20, 30, 10, 15))
#' \dontrun{
#' # visualize the NLM
#' terra::plot(distance_gradient)
#' }
#' @seealso \code{\link{nlm_edgegradient}},
#' \code{\link{nlm_planargradient}}
#'
#' @aliases nlm_distancegradient
#' @rdname nlm_distancegradient
#'
#' @export
nlm_distancegradient <- function(ncol,
                                 nrow,
                                 resolution = 1,
                                 origin,
                                 rescale = TRUE) {
  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_vector(origin, any.missing = FALSE)
  checkmate::assert_true(origin[2] <= ncol)
  checkmate::assert_true(origin[4] <= nrow)
  checkmate::assert_logical(rescale)

  # create empty raster ----
  distancegradient <-
    terra::rast(ncol = ncol, nrow = nrow,
                xmin = 0, xmax = ncol,
                ymin = 0, ymax = nrow)
  terra::values(distancegradient) <- NA

  # set origin to 1 ----
  distancegradient[origin[1]:origin[2], origin[3]:origin[4]] <- 1

  # measure distance to origin ----
  suppressWarnings(distancegradient <-
    terra::distance(distancegradient))

  # specify resolution ----
  terra::ext(distancegradient) <- c(
    0,
    terra::ncol(distancegradient) * resolution,
    0,
    terra::nrow(distancegradient) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    distancegradient <- util_rescale(distancegradient)
  }

  distancegradient <- util_update_metadata(distancegradient)

  return(distancegradient)
}
