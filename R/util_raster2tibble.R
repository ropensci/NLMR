#' Converts raster data into tibble
#'
#' @description Writes spatial raster values into tibble and adds coordinates.
#'
#' @details You will loose any resolution, extent or reference system.
#' The output is raw tiles.
#'
#' @param x [\code{Raster* object}]
#'
#' @return a tibble
#'
#' @examples
#' library(ggplot2)
#' rndMap <- nlm_random(16, 9)
#' maptib <- util_raster2tibble(rndMap)
#' ggplot(maptib, aes(x,y)) +
#'   coord_fixed() +
#'   geom_raster(aes(fill = z))
#'
#' @aliases util_raster2tibble
#' @rdname util_raster2tibble
#'
#' @export
#'

util_raster2tibble <- function(x) {

  # Check function arguments ----
  checkmate::assert_class(x, "RasterLayer")

  # Create empty tibble with the same dimension as the raster ----
  grd <- tibble::as_tibble(expand.grid(x = seq(1, raster::ncol(x)),
                                       y = seq(raster::nrow(x), 1)))

  # Fill with raster values ----
  grd <- dplyr::bind_cols(grd, z = raster::values(x))

  return(grd)
}
