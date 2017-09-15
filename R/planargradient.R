#' planargradientNLM
#'
#' Create a planar gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param direction [\code{numerical(1)}]\cr Direction of the gradient, if unspecified the direction is randomly determined.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#'
#' @examples
#' planargradientNLM(nCol = 100, nRow = 100)
#'
#'
#' @aliases planargradientNLM
#' @rdname planargradientNLM
#'
#' @export
#'


planargradientNLM  <- function(nCol,
                              nRow,
                              direction = NA,
                              rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(direction)
  checkmate::assert_logical(rescale)

  # If direction was not set, give it a random value between 0 and 360 ----
  if (is.na(direction)) {
    direction <- stats::runif(1, 0, 360)
  }

  # Determine the eastness and southness of the direction ----
  eastness   <- sin(pracma::deg2rad(direction))
  southness  <- cos(pracma::deg2rad(direction)) * -1

  # Create arrays of row and column index ----
  col_index <- matrix(0:(nCol - 1), nCol, nRow)
  row_index <- matrix(0:(nRow - 1), nCol, nRow, byrow = TRUE)

  # Create gradient matrix ----
  gradient_matrix  <-
    (southness * row_index + eastness * col_index)

  # Transform to raster ----
  gradient_raster <- raster::raster(gradient_matrix)

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    gradient_raster <- rescaleNLM(gradient_raster)
  }

  return(gradient_raster)

}
