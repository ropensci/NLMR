#' Method distancegradientNLM
#' @name rescaleNLM-method
#' @rdname rescaleNLM-method
#' @exportMethod rescaleNLM

setGeneric("rescaleNLM", function(r) {
  standardGeneric("rescaleNLM")
})


#' rescaleNLM
#'
#' A rescale in which the values in the raster are linearly rescaled to range between 0 and 1.
#'
#' @param r RasterLayer containing a neutral landscape
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#'
#' @examples
#' \dontrun{
#' rescaleNLM(rasterNLM)
#' }
#'
#' @aliases rescaleNLM
#' @rdname rescaleNLM-method
#'
#' @export
#'

setMethod(
  "rescaleNLM",
  signature = signature("RasterLayer"),
  definition = function(r) {
    rescaledNLM <-
      (r - raster::cellStats(r, "min")) / (raster::cellStats(r, "max") - raster::cellStats(r, "min"))

    return(rescaledNLM)


  }
)
