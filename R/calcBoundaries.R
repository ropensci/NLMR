#' Method calcBoundaries
#' @name calcBoundaries-method
#' @rdname calcBoundaries-method
#' @exportMethod calcBoundaries

setGeneric("calcBoundaries", function(array, cumulativeProportions) {
  standardGeneric("calcBoundaries")
})


#' calcBoundaries
#'
#' Determine upper class boundaries for classification of an array with values ranging 0-1 based upon an
#' array of cumulative proportions.
#'
#' @param array 2D array of data values
#' @param cumulativeProportions 1D array of class cumulative proportions
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#'
#' @examples
#' \dontrun{
#' calcBoundaries(rasterNLM)
#' }
#'
#' @aliases calcBoundaries
#' @rdname calcBoundaries-method
#'
#' @export
#'

setMethod(
  "calcBoundaries",
  signature = signature("matrix"),
  definition = function(array, cumulativeProportions) {

    # Determine the number of cells that are in the classification area
    nCells <- length(array)

    # Based on the number of cells, find the index of upper boundary element
    boundaryIndexes <- as.integer((cumulativeProportions * nCells) - 1)

    # Index out the the upper boundary value for each class
    boundaryValues <- sort(array)[boundaryIndexes]

    # Ensure the maximum boundary value is equal to 1
    boundaryValues[max(length(boundaryValues))] = 1
    return(boundaryValues)


  }
)






