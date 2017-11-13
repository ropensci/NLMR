#' util_rescale
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
#' # since NLMR uses rescale as the default, one would use it like this
#' # (or simply set the parameter to \code{FALSE})
#' util_rescale(nlm_random(10, 10,  rescale = FALSE))
#'
#'
#' @aliases util_rescale
#' @rdname util_rescale
#'
#' @export
#'

util_rescale <- function(r) {
    rescaled_NLM <-
      (r - raster::cellStats(r, "min")) /
                   (raster::cellStats(r, "max") - raster::cellStats(r, "min"))

    return(rescaled_NLM)


  }
