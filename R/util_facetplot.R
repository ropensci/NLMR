#' util_facetplot() prototype skeleton
#'
#' @description turns raster stuff into magnificent facet plot.
#'
#' @details You will loose any resolution, extent or reference system,
#' but the output is beautiful.
#'
#' @param x [\code{Raster* object}], Layer Brick whatever. Works even with a list.
#'
#' @return ggplot
#'
#' @examples
#' l1 <- nlm_fBm(64, 64)
#' l2 <- nlm_planargradient(64, 64)
#' l3 <- nlm_mosaicfield(42, 42)
#' 
#' bri1 <- raster::brick(l1, l2)
#' util_facetplot(bri1)
#' 
#' lst1 <- list(lay1 = l1,
#'              lay2 = l2,
#'              lay3 = l3,
#'              lay4 = nlm_random(70, 70))
#' util_facetplot(lst1)
#'
#' @aliases util_facetplot
#' @rdname util_facetplot
#' @include util_raster2tibble.R
#'
#' @export
#'

util_facetplot <- function(x) {

  if (checkmate::testClass(x, "RasterLayer") ||
      checkmate::testClass(x, "RasterStack") ||
      checkmate::testClass(x, "RasterBrick")) {

    maplist <- list()
    for (i in seq_len(raster::nlayers(x))) {
      maplist <- append(maplist, list(raster::raster(x, layer = i)))
    }
    x <- magrittr::set_names(maplist, names(x))
  }

  maptibb <- tibble::enframe(x, "id", "maps") %>%
             dplyr::mutate(maps = purrr::map(.$maps, util_raster2tibble)) %>%
             unnest

  p <- ggplot2::ggplot(maptibb, aes(x, y)) +
        ggplot2::coord_fixed() +
        ggplot2::geom_raster(aes(fill = z)) +
        ggplot2::facet_wrap(~id) +
        theme_nlm()

  return(p)
}
