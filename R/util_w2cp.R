#' util_w2cp
#'
#' Convert a list of category  weighting  into a 1D array of cumulative proportions.
#'
#' @param  weighting  A list of numeric values
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#'
#' @examples
#' util_w2cp(c(0.2, 0.4, 0.6, 0.9))
#'
#'
#' @keywords internal
#' @export

util_w2cp <- function(weighting) {
  w <- weighting
  proportions <- w / sum(w)
  cumulative_proportions <- cumsum(proportions)
  return(cumulative_proportions)
}
