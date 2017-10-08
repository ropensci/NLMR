#' util_classify
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
#' x <- matrix(runif(100, 0, 1), 10, 10)
#' y <- c(0.5, 0.25, 0.25)
#' util_classify(x, y)
#'
#'
#' @aliases util_classify
#' @rdname util_classify
#'
#' @export
#'

util_classify <- function(x, weighting) {

  # Check function arguments ----
  checkmate::assert_matrix(x, min.rows = 1, min.cols = 1)
  checkmate::assert_numeric(weighting)

  # Calculate cum. proportions and boundary values ----
  cumulative_proportions  <- util_w2cp(weighting)
  boundary_values  <- util_calc_boundaries(x, cumulative_proportions)

  # Classify the matrix based on the boundary values ----
  classified_matrix <-
    matrix(findInterval(x, boundary_values),
           dim(x)[1],
           dim(x)[2])

  return(classified_matrix)
}
