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
#' w2cp(c(0.5, 0.4, 0.6))
#'
#'
#' @aliases w2cp
#' @rdname w2cp-method
#'
#' @export
#'

w2cp <- function(weighting) {

  w <-  weighting
  proportions <- w / sum(w)
  cumulative_proportions <- cumsum(proportions)
  cumulative_proportions[max(length(proportions))]  <- 1
  return(cumulative_proportions)

}


#####
# Sebastians comment: Test cumsum if always 1, get rid of manual placement of 1
#####
