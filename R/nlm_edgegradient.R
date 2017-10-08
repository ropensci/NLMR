#' nlm_edgegradient
#'
#' Create an edge gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param direction [\code{numerical(1)}]\cr Direction of the gradient (between 0 and 360 dec), if unspecified the direction is randomly determined.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with xxxxxxx.
#'
#' @examples
#' nlm_edgegradient(nCol = 100, nRow = 100, direction = 80)
#'
#' @aliases nlm_edgegradient
#' @rdname nlm_edgegradient
#'
#' @export
#'

nlm_edgegradient <- function(nCol, nRow, direction = NA, rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(direction)
  checkmate::assert_logical(rescale)

  # If direction was not set, give it a random value between 0 and 360 ---
  if (is.na(direction)) {
    direction <- stats::runif(1, 0, 360)
  }

  # Create planar gradient ----
  gradient_raster <-  nlm_planargradient(50, 50, direction)

  # Transform to a central gradient ----
  edgegradient_raster <-
    (abs(0.5 - gradient_raster) * -2) + 1

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    edgegradient_raster <- util_rescale(edgegradient_raster)
  }

  return(edgegradient_raster)
}

#####
# Sebastians comment: Make transformation to planar gradient adjustable by the user
#####

