#' randomNLM
#'
#' @description Create a spatially random neutral landscape model with values from a uniform distribution.
#'
#'
#' @details
#' The function takes the number of columns and rows as input and creates a RasterLayer with the same extent.
#' Each raster cell is randomly assigned a value between 0 and 1 drawn from an uniform distribution (\code{runif(1,0,1)}).
#' If the parameter \code{rescale == TRUE} than the minimum and maximum value are used to rescale the cell values to a range between 0 and 1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values.
#'
#'
#' @examples
#' randomNLM(nCol = 100, nRow = 100)
#'
#'
#' @aliases randomNLM
#' @rdname randomNLM
#'
#' @export
#'

randomNLM  <-  function(nCol, nRow, rescale = TRUE) {

    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_logical(rescale)

    # Assign random values to raster cells ----
    random_raster <-
      raster::raster(matrix(stats::runif(nCol * nRow, 0, 1), nCol, nRow))

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      random_raster <- rescaleNLM(random_raster)
    }

    return(random_raster)

}
