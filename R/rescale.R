#' rescaleNLM
#'
#' A rescale in which the values in the raster are linearly rescaled to range between 0 and 1.
#'
#' @param r [\code{Raster* object}]
#'
#' @return Raster* object with values ranging from 0-1
#'
#'
#' @examples
#'
#' rescaleNLM(randomNLM(10,10))
#'
#'
#' @aliases rescaleNLM
#' @rdname rescaleNLM
#'
#' @export
#'

rescaleNLM <- function(r) {
    rescaled_NLM <-
      (r - raster::cellStats(r, "min")) /
                   (raster::cellStats(r, "max") - raster::cellStats(r, "min"))

    return(rescaled_NLM)


  }
