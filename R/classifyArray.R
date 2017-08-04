#' Method classifyArray
#' @name classifyArray-method
#' @rdname classifyArray-method
#' @exportMethod classifyArray

setGeneric("classifyArray", function(array, weighting) {
  standardGeneric("classifyArray")
})


#' classifyArray
#'
#' Classify an array with values ranging 0-1 into proportions based upon a list of class  weighting .
#'
#' @param array 2D array of data values
#' @param  weighting  A list of numeric values
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#'
#' @examples
#' \dontrun{
#' classifyArray(rasterNLM)
#' }
#'
#' @aliases classifyArray
#' @rdname classifyArray-method
#'
#' @export
#'

setMethod(
  "classifyArray",
  signature = signature("matrix"),
  definition = function(array, weighting) {

    cumulativeProportions = w2cp(weighting)
    boundaryValues = calcBoundaries(array, cumulativeProportions)

    # Classify the array based on the boundary values
    classifiedArray <- matrix(findInterval(array, boundaryValues), dim(array)[1], dim(array)[1])

    return(classifiedArray)

  }
)


#
# classifyArray <- function(array,  weighting ) {
#   cumulativeProportions = w2cp(weighting)
#   boundaryValues = calcBoundaries(array, cumulativeProportions)
#
#   # Classify the array based on the boundary values
#   classifiedArray <- matrix(findInterval(array, boundaryValues), dim(array)[1], dim(array)[1])
#
#   return(classifiedArray)
# }
