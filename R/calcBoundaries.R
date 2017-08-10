#' calcBoundaries
#'
#' @description Determine upper class boundaries for classification of a matrix with values ranging 0-1 based upon an
#' vector of cumulative proportions.
#'
#' @param x [\code{matrix(x,y)}]\cr 2D matrix of data values.
#' @param cumulativeProportions [\code{numerical}]\cr Vector of class cumulative proportions.
#'
#' @return Numerical vector with boundaries for matrix classifcation
#'
#'
#' @examples
#' x <- matrix(runif(100,0,1),10,10)
#' y <- c(0.5, 0.25, 0.25)
#' calcBoundaries(x,y)
#'
#' @aliases calcBoundaries
#' @rdname calcBoundaries
#'
#' @export
#'

calcBoundaries <- function(x, cumulativeProportions) {

  # Check function arguments ----
  checkmate::assert_matrix(x, min.rows = 1, min.cols = 1)
  checkmate::assert_numeric(cumulativeProportions)

  # Get number of cells  ----
  nCells <- length(x)

  # Use number of cells to find index of upper boundary element ----
  boundaryIndexes <- as.integer((cumulativeProportions * nCells) - 1)

  # Get boundary values ----
  boundaryValues <- sort(x)[boundaryIndexes]

  # Always set the maximum boundary value to 1 ----
  boundaryValues[max(length(boundaryValues))] = 1

  return(boundaryValues)

}

