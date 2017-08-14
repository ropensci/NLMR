#' calcBoundaries
#'
#' @description Determine upper class boundaries for classification of a matrix with values ranging 0-1 based upon an
#' vector of cumulative proportions.
#'
#' @param x [\code{matrix(x,y)}]\cr 2D matrix of data values.
#' @param cumulative_proportions [\code{numerical}]\cr Vector of class cumulative proportions.
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

calcBoundaries <- function(x, cumulative_proportions) {

  # Check function arguments ----
  checkmate::assert_matrix(x, min.rows = 1, min.cols = 1)
  checkmate::assert_numeric(cumulative_proportions)

  # Get number of cells  ----
  n_cells <- length(x)

  # Use number of cells to find index of upper boundary element ----
  boundary_indexes <- as.integer( (cumulative_proportions * n_cells) - 1)

  # Get boundary values ----
  boundary_values <- sort(as.vector(x))[boundary_indexes]

  # Always set the maximum boundary value to 1 ----
  boundary_values[max(length(boundary_values))] <-  1

  return(boundary_values)

}
