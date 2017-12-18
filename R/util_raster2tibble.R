#' Converts raster data into tibble
#'
#' @description Writes spatial raster values into tibble and adds coordinates.
#'
#' @details You will loose any resolution, extent or reference system. 
#' The output is raw tiles.
#'
#' @param x [\code{Raster* object}]
#'
#'
#' @return a tibble
#'
#' @examples
#' rndMap <- nlm_random(16, 9)
#' maptib <- util_raster2tibble(rndMap)
#' ggplot(maptib, aes(x,y)) +
#'   coord_fixed() +
#'   geom_raster(aes(fill = z))
#' 
#'
#' @aliases util_raster2tibble
#' @rdname util_raster2tibble
#'
#' @export
#'

util_raster2tibble <- function(rst) {
  
  # Check function arguments ----
  checkmate::assert_class(rst, "RasterLayer")
  
  grd <- tibble::as_tibble(expand.grid(x = 1:raster::ncol(rst), 
                                       y = raster::nrow(rst):1))
  grd <- bind_cols(grd, z = raster::values(rst))
  
  return(grd)
}
