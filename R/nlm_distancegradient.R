#' nlm_distancegradient
#'
#' @description Simulate a distance gradient neutral landscape model.
#'
#' @details
#' The function takes the number of columns and rows as input and creates a
#' RasterLayer with the same extent. \code{Origin} is a numeric vector of
#' xmin, xmax, ymin, ymax for a rectangle inside the raster from which the
#' distance is measured.
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param origin  [\code{numerical(4)}]\cr
#' Edge coordinates of the origin of the distance measurement.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#' Otherwise, the distance in raster units is calculated.
#'
#' @return RasterLayer
#'
#' @examples
#'
#' # simulate a distance gradient
#' (distance_gradient <- nlm_distancegradient(nCol = 100, nRow = 100,
#'                                            origin = c(20, 30, 10, 15)))
#' \dontrun{
#' # visualize the NLM
#' util_plot(distance_gradient)
#' }
#' @seealso \code{\link{nlm_edgegradient}},
#' \code{\link{nlm_planargradient}}
#'
#' @aliases nlm_distancegradient
#' @rdname nlm_distancegradient
#'
#' @export
#'

nlm_distancegradient <- function(nCol,
                                 nRow,
                                 resolution = 1,
                                 origin,
                                 rescale = TRUE) {
  # raster::distance would produce an annyoing warning
  # because of a missing CRS
  suppressWarnings("In couldBeLonLat(x) : CRS is NA.
                     Assuming it is longitude/latitude")

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_vector(origin, any.missing = FALSE)
  checkmate::assert_true(origin[2] <= nCol)
  checkmate::assert_true(origin[4] <= nRow)
  checkmate::assert_logical(rescale)

  # create empty raster ----
  distancegradient <-
    raster::raster(ncol = nCol, nrow = nRow,
                   ext = raster::extent(c(0, 1, 0, 1)))

  # set origin to 1 ----
  distancegradient[origin[1]:origin[2], origin[3]:origin[4]] <- 1

  # measure distance to origin ----
  suppressWarnings(distancegradient <-
    raster::distance(distancegradient))

  # specify resolution ----
  raster::extent(distancegradient) <- c(
    0,
    ncol(distancegradient) * resolution,
    0,
    nrow(distancegradient) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    distancegradient <- util_rescale(distancegradient)
  }

  return(distancegradient)
}
