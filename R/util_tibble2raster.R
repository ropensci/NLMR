#' Converts tibble data into a raster
#'
#' @description Writes spatial tibble values into a raster.
#'
#' @details Writes tiles with coordinates from a tibble into a raster.
#' Resolution is set to 1 and the extent will be c(0, max(x), 0, max(y)).
#'
#' You can directly convert back the result from 'util_raster2tibble()' without
#' problems. If you have altered the coordinates or otherwise played with the
#' data, be careful while using this function.
#'
#'
#' @param x a tibble
#'
#' @return [\code{Raster* object}]
#'
#' @examples
#' rndMap <- nlm_random(16, 9)
#' maptib <- util_raster2tibble(rndMap)
#' mapras <- util_tibble2raster(maptib)
#' all.equal(rndMap, mapras)
#'
#' @aliases util_tibble2raster
#' @rdname util_tibble2raster
#'
#' @export
#'

util_tibble2raster <- function(x) {

  # Create raster with values from tibble ----
  r <- raster::raster(matrix(x$z, max(x$y), max(x$x), byrow = TRUE))
  raster::extent(r) <- c(0, max(x$x), 0, max(x$y))

  return(r)
}
