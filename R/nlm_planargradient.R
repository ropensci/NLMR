#' nlm_planargradient
#'
#' @description Create a planar gradient neutral landscape model.
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param direction [\code{numerical(1)}]\cr
#' Direction of the gradient in degrees, if unspecified the direction is randomly
#' determined.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @details
#' Simulates a linear gradient sloping in a specified or random direction.
#'
#' @examples
#' nlm_planargradient(nCol = 100, nRow = 100)
#'
#' @references
#' Palmer, M.W. (1992) The coexistence of species in fractal landscapes.
#' \emph{The American Naturalist}, 139, 375 - 397.
#'
#' @aliases nlm_planargradient
#' @rdname nlm_planargradient
#'
#' @export
#'


nlm_planargradient  <- function(nCol,
                                nRow,
                                resolution = 1,
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

  # specify resolution ----
  raster::extent(gradient_raster) <- c(0,
                                  ncol(gradient_raster)*resolution,
                                  0,
                                  nrow(gradient_raster)*resolution)

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    gradient_raster <- util_rescale(gradient_raster)
  }

  return(gradient_raster)

}
