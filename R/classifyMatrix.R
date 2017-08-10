#' classifyMatrix
#'
#' @description Classify a matrix with values ranging 0-1 into proportions based upon a vector of class weightings.
#'
#' @details  The length of the weighting vector determines the number of classes in the resulting matrix.
#'
#' @param x [\code{matrix(x,y)}]\cr 2D matrix of data values.
#' @param weighting [\code{numerical}]\cr  Vector of numeric values.
#'
#' @return Rectangular matrix reclassified values.
#'
#' @examples
#' x <- matrix(runif(100,0,1),10,10)
#' y <- c(0.5, 0.25, 0.25)
#' classifyMatrix(x,y)
#'
#'
#' @aliases classifyMatrix
#' @rdname classifyMatrix
#'
#' @export
#'

classifyMatrix <- function(x, weighting) {

  # Check function arguments ----
  checkmate::assert_matrix(x, min.rows = 1, min.cols = 1)
  checkmate::assert_numeric(weighting)

  # Calculate cum. proportions and boundary values ----
  cumulativeProportions = w2cp(x)
  boundaryValues = calcBoundaries(x, cumulativeProportions)

  # Classify the matrix based on the boundary values
  classifiedMatrix <-
    matrix(findInterval(x, boundaryValues),
           dim(x)[1],
           dim(x)[2])

  return(classifiedMatrix)

}
