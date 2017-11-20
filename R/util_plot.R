#' util_plot
#'
#' Plot a Raster* object with the NLMR default theme
#'
#' @param x [\code{Raster* object}]
#' @param scale [\code{character}(1)]
#' Five options are available: "viridis - magma" (= "A"),
#'                             "viridis - inferno" (= "B"),
#'                             "viridis - plasma" (= "C"),
#'                             "viridis - viridis" (= "D", the default option)
#' @param discrete [\code{logical}(1)] If TRUE, the function plots a raster with
#' a discrete legend.
#' @param legendposition [\code{character}(1)] The position of legends
#' ("none", "left", "right", "bottom", "top")
#' @param legendtitle [\code{character}(1)]
#' Title for legend
#' @return ggplot2 Object
#'
#' @examples
#'
#' # With continuous data
#' nlm_raster <- nlm_random(10,10)
#' util_plot(nlm_raster, scale = "D")
#'
#' # With classified data
#' y <- c(0.5, 0.15, 0.25)
#' nlm_raster <- util_classify(nlm_raster, y)
#' util_plot(nlm_raster, scale = "D", discrete = TRUE)
#'
#' # for rasterstacks or bricks, use:
#' nlm_1 <- nlm_random(100, 100, resolution = 10)
#' nlm_2 <- nlm_percolation(100,100, 0.3, resolution = 10)
#' nlm_3 <- nlm_edgegradient(100, 100, 0.3, resolution = 10)
#' nlm_4 <- nlm_randomelement(100, 100, n = 150, resolution = 10)
#' nlm_brick <- raster::brick(nlm_1,nlm_2,nlm_3,nlm_4)
#' util_plot(nlm_brick)
#'
#'
#' @aliases util_plot
#' @rdname util_plot
#'
#' @export
#'

util_plot <- function(x,
                      scale = "A",
                      discrete = FALSE,
                      legendposition = "bottom",
                      legendtitle = "Z") {

  if(raster::nlayers(x) == 1){

    if (isTRUE(discrete)) {


      raster_labels = tryCatch({
        x@data@attributes[[1]][,2]
      }, error = function(e) {
        x <- raster::as.factor(x)
        levels <- raster::unique(x)
        x@data@attributes[[1]][,2] <- levels
      })

      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = factor(value))) +
        ggplot2::coord_equal() +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +
        ggplot2::theme(
          legend.position = legendposition,
          text = ggplot2::element_text(color = "#22211d"),
          axis.line = ggplot2::element_line(),
          axis.ticks.length = ggplot2::unit(.15, "cm"),
          axis.ticks = ggplot2::element_line(),
          panel.background = ggplot2::element_blank(),
          panel.border = ggplot2::element_blank(), # bg of the panel
          plot.background = ggplot2::element_rect(fill = "transparent"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          legend.background = ggplot2::element_rect(fill = "transparent"),
          legend.box.background = ggplot2::element_rect(fill = "transparent",
                                                        color = NA),
          strip.background = ggplot2::element_rect(colour = NA, fill = "grey45"),
          aspect.ratio=1,
          plot.title = ggplot2::element_text(hjust = 0.5)
        ) +
        viridis::scale_fill_viridis(
          option = scale,
          direction = -1,
          discrete = TRUE,
          labels = raster_labels,
          na.value = "transparent",
          name = legendtitle,
          guide = ggplot2::guide_legend(
            direction = "horizontal",
            barheight = ggplot2::unit(2, units = "mm"),
            barwidth = ggplot2::unit(50, units = "mm"),
            draw.ulim = FALSE,
            title.position = "top",
            title.hjust = 0.5,
            label.hjust = 0.5
          )) +
        lemon::coord_capped_cart(
          xlim = c(raster::extent(x)[1],
                   raster::extent(x)[2]),
          ylim = c(raster::extent(x)[3],
                   raster::extent(x)[4]),
          left = "both", bottom = "both")
    } else {
      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = value)) +
        ggplot2::coord_equal() +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +
        ggplot2::theme(
          legend.position = legendposition,
          text = ggplot2::element_text(color = "#22211d"),
          axis.line = ggplot2::element_line(),
          axis.ticks.length = ggplot2::unit(.15, "cm"),
          axis.ticks = ggplot2::element_line(),
          panel.background = ggplot2::element_blank(),
          panel.border = ggplot2::element_blank(), # bg of the panel
          plot.background = ggplot2::element_rect(fill = "transparent"),
          panel.grid.major = ggplot2::element_blank(),
          panel.grid.minor = ggplot2::element_blank(),
          legend.background = ggplot2::element_rect(fill = "transparent"),
          legend.box.background = ggplot2::element_rect(fill = "transparent",
                                                        color = NA),
          strip.background = ggplot2::element_rect(colour = NA, fill = "grey45"),
          aspect.ratio=1,
          plot.title = ggplot2::element_text(hjust = 0.5)
        ) +
        viridis::scale_fill_viridis(
          option = scale,
          direction = -1,
          na.value = "transparent",
          name = "Z",
          guide = ggplot2::guide_colorbar(
            direction = "horizontal",
            barheight = ggplot2::unit(2, units = "mm"),
            barwidth = ggplot2::unit(50, units = "mm"),
            draw.ulim = FALSE,
            title.position = "top",
            title.hjust = 0.5,
            label.hjust = 0.5
          )) +
        lemon::coord_capped_cart(
          xlim = c(raster::extent(x)[1],
                   raster::extent(x)[2]),
          ylim = c(raster::extent(x)[3],
                   raster::extent(x)[4]),
          left = "both", bottom = "both")
    }

  } else {
    rasterVis::levelplot(x)
  }

}
