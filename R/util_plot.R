#' util_plot
#'
#' Plot a Raster* object with the NLMR default theme
#'
#' @param x [\code{Raster* object}]
#' @param scale [\code{character}(1)]
#' Five options are available: "viridis - magma" (= "A"),
#'                             "viridis - inferno" (= "B"),
#'                             "viridis - plasma" (= "C"),
#'                             "viridis - viridis" (= "D",  the default option)
#' @param discrete [\code{logical}(1)] If TRUE, the function plots a raster with
#' a discrete legend.
#' @param legendposition [\code{character}(1)] The position of legends
#' ("none", "left", "right", "bottom", "top")
#' @param legendtitle [\code{character}(1)]
#' Title for legend
#' @return ggplot2 Object
#'
#' @examples
#' \dontrun{
#' # With continuous data
#' nlm_raster <- nlm_random(10,10)
#' util_plot(nlm_raster, scale = "D")
#'
#' # With classified data
#' y <- c(0.5, 0.15, 0.25)
#' nlm_raster <- util_classify(nlm_raster, y)
#' util_plot(nlm_raster, scale = "D", discrete = TRUE)
#' }
#'
#' @aliases util_plot
#' @rdname util_plot
#'
#' @export
#'

util_plot <- function(x,
                      scale = "D",
                      discrete = FALSE,
                      legendposition = "bottom",
                      legendtitle = "Z") {

  if (raster::ncol(x) == raster::nrow(x)) {
    ratio <- 1
  } else {
    ratio <- raster::nrow(x) / raster::ncol(x)
  }

  if (raster::nlayers(x) == 1) {

    if (isTRUE(discrete)) {
      raster_labels <- tryCatch({
        x@data@attributes[[1]][, 2]
      }, error = function(e) {
        x <- raster::as.factor(x)
        levels <- raster::unique(x)
        x@data@attributes[[1]][, 2] <- levels
      })

      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = factor(value))) +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +



        viridis::scale_fill_viridis(
          option = scale,
          direction = 1,
          discrete = TRUE,
          labels = raster_labels,
          na.value = "transparent",
          name = legendtitle,
          guide = ggplot2::guide_legend(
            direction = "horizontal",
            barheight = ggplot2::unit(1, units = "mm"),
            barwidth = ggplot2::unit(40, units = "mm"),
            draw.ulim = FALSE,
            title.position = "top",
            title.hjust = 0.5,
            label.hjust = 0.5
          )
        ) +
        lemon::coord_capped_cart(
          xlim = c(raster::extent(x)[1],
                   raster::extent(x)[2]),
          ylim = c(raster::extent(x)[3],
                   raster::extent(x)[4]),
          left = "both",
          bottom = "both"
        )
    } else {
      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = value)) +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +
        theme_nlm()
    }
  } else {
    rasterVis::levelplot(x)
  }
}
