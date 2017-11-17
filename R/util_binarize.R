#' Binarize continuous raster values
#'
#' @description Reclassify continuous raster values into binary map cells based upon given
#' break(s).
#'
#' @details Breaks are considerred to be habitat percentages (p). If more than
#' one percentage is given multiple layers are written in the same brick.
#'
#' @param nlm_obj [\code{Raster* object}]
#'
#' @param breaks a vector with one or more break percentages
#'
#'
#' @return RasterBrick
#'
#' @examples
#' rndMap <- nlm_random(10, 10)
#' brks <- c(0.3, 0.5, 0.7)
#' util_binarize(rndMap, brks)
#'
#'
#' @aliases util_binarize
#' @rdname util_binarize
#'
#' @export
#'

util_binarize <- function(nlm_obj, breaks) {
  map.stack <- stack()
  for (i in seq_along(breaks)) {
    map.stack <- stack(map.stack,
                       util_classify(nlm_obj, c(breaks[i], 1 - breaks[i]), c("Habitat", "Deadzone")))
  }
  names(map.stack) <- paste("p", breaks)
  brick(map.stack)
}
