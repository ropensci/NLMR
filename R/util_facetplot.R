#' util_facetplot() for visual overview
#'
#' @description Plot multiple raster (RasterStack, -brick or list of raster) side by side as facets.
#'
#' @details The output uses ggplots faceting and beforehand raster2tibble.
#' Thus you will loose any spatial information (resolution, extent or reference system).
#' Only raw tiles are displayed and the number of cells determines the size of the plot.
#' This can lead to huge size differences between maps, but if you plot for example
#' multiple maps from a time series side by side it works as intended. Depending on the
#' size of the maps it is advisable to store the plot in an object and print it to
#' a file. This will help with compressing and rendering the image.
#'
#' @param x [\code{Raster* object}] (Layer, Stack, Brick) or a list of rasterLayers.
#' @param nrow,ncol Number of rows and columns.
#'
#' @return ggplot
#'
#' @examples
#' \dontrun{
#' l1 <- nlm_fBm(64, 64)
#' l2 <- nlm_planargradient(64, 64)
#' l3 <- nlm_randomrectangularcluster(ncol = 60, nrow = 60, minl = 5, maxl = 10)
#' l4 <- nlm_random(64, 64)
#'
#' bri1 <- raster::brick(l1, l2)
#' util_facetplot(bri1)
#'
#' lst1 <- list(layer1 = l1,
#'              layer2 = l2,
#'              layer3 = l3,
#'              layer4 = l4)
#' util_facetplot(lst1)
#' }
#'
#' @aliases util_facetplot
#' @rdname util_facetplot
#'
#' @export
#'

util_facetplot <- function(x, nrow = NULL, ncol = NULL) {

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
             tidyr::unnest()

  p <- ggplot2::ggplot(maptibb, ggplot2::aes_string("x", "y")) +
        ggplot2::coord_fixed() +
        ggplot2::geom_raster(ggplot2::aes_string(fill = "z")) +
        ggplot2::facet_wrap(~id, nrow = nrow, ncol = ncol) +
        theme_nlm()

  return(p)
}
