#' nlm_distancegradient
#'
#' @description Simulates a distance-gradient neutral landscape model.
#'
#' @details
#' \code{origin} uses inclusive, 1-based cell indices; rows are numbered from
#' top to bottom. Cells inside the selected rectangle have distance zero. With
#' \code{rescale = FALSE}, distances are multiplied by \code{resolution}.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param origin  [\code{numerical(4)}]\cr
#' Rectangular origin as 1-based cell indices:
#' \code{c(first_column, last_column, first_row, last_row)}.
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
  checkmate::assert_number(resolution, lower = .Machine$double.eps,
                           finite = TRUE)
  checkmate::assert_integerish(origin, len = 4, lower = 1,
                               any.missing = FALSE)
  checkmate::assert_true(origin[1] <= origin[2])
  checkmate::assert_true(origin[3] <= origin[4])
  checkmate::assert_true(origin[2] <= ncol)
  checkmate::assert_true(origin[4] <= nrow)
  checkmate::assert_logical(rescale)

  # create empty raster ----
  distancegradient <-
    terra::rast(ncol = ncol, nrow = nrow,
                xmin = 0, xmax = ncol * resolution,
                ymin = 0, ymax = nrow * resolution,
                crs = "")
  terra::values(distancegradient) <- NA_real_

  # set origin and measure distance ----
  distancegradient[origin[3]:origin[4], origin[1]:origin[2]] <- 1
  suppressWarnings(distancegradient <- terra::distance(distancegradient))

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    distancegradient <- util_rescale(distancegradient)
  }

  distancegradient <- util_update_metadata(distancegradient)

  return(distancegradient)
}
