#' Method w2cp
#' @name w2cp-method
#' @rdname w2cp-method
#' @exportMethod w2cp

setGeneric("w2cp", function( weighting ) {
  standardGeneric("w2cp")
})


#' w2cp
#'
#' Convert a list of category  weighting  into a 1D array of cumulative proportions.
#'
#' @param  weighting  A list of numeric values
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#'
#' @examples
#' \dontrun{
#' w2cp(rasterNLM)
#' }
#'
#' @aliases w2cp
#' @rdname w2cp-method
#'
#' @export
#'

setMethod(
  "w2cp",
  definition = function( weighting ) {

    w <-  weighting
    proportions <- w/sum(w)
    cumulativeProportions <- cumsum(proportions)
    cumulativeProportions[max(length(proportions))]  <- 1
    return(cumulativeProportions)

    }
)



# w2cp <- function( weighting ) {
#
#   w <-  weighting
#   proportions <- w/sum(w)
#   cumulativeProportions <- cumsum(proportions)
#   cumulativeProportions[max(length(proportions))]  <- 1
#   return(cumulativeProportions)
#
# }
