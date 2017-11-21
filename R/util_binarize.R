#' Binarize continuous raster values
#'
#' @description Reclassify continuous raster values into binary map cells based upon given
#' break(s).
#'
#' @details Breaks are considerred to be habitat percentages (p). If more than
#' one percentage is given multiple layers are written in the same brick.
#'
#' @param x [\code{Raster* object}]
#'
#' @param breaks a vector with one or more break percentages
#'
#'
#' @return RasterBrick
#'
#' @examples
#' rndMap <- nlm_random(10, 10)
#' breaks <- c(0.3, 0.5, 0.7, 0.9)
#' rnd_bin <- util_binarize(rndMap, breaks)
#' util_plot(rnd_bin)
#'
#' @aliases util_binarize
#' @rdname util_binarize
#'
#' @export
#'

util_binarize <- function(x, breaks) {

  # Check function arguments ----
  checkmate::assert_class(x, "RasterLayer")
  checkmate::assert_atomic_vector(breaks)

  map.stack <- raster::stack()
  for (i in seq_along(breaks)) {
    map.stack <- raster::stack(map.stack,
                       util_classify(x, c(breaks[i], 1 - breaks[i]), c("Habitat", "Matrix")))
  }

  names(map.stack) <- paste("p ", breaks, sep = " ")
  raster::brick(map.stack)

}
