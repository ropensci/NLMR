#' percolationNLMR
#'
#' Create a simple neutral landscape model with either 0 or 1 as values.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param prob [\code{numerical(1)}]\cr Probability value for setting a cell either to 0 or 1.
#'
#' @return RasterLayer with random values 0 amd 1.
#'
#'
#' @examples
#' percolationNLMR(nCol = 100, nRow = 100, p=0.5)
#'
#'
#' @aliases percolationNLMR
#' @rdname percolationNLMR
#'
#' @export
#'

percolationNLMR  <- function(nCol,
                             nRow,
                             prob) {

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_true(prob <= 1, na.ok = FALSE)
  checkmate::assert_true(prob >= 0, na.ok = FALSE)

  percolation_matrix <- matrix(NA, nrow = nRow, ncol = nCol)

  percolation_matrix[] <- vapply(percolation_matrix, function(x){ifelse(runif(1,0,1) < prob, 1, 0)}, numeric(1))

  percolation_raster <-
    raster::raster(percolation_matrix)

  return(percolation_raster)

}

raster::plot(percolationNLMR(1000, 1000, 0.7))

