#' util_plot
#'
#' Plot a Raster* object with the NLMR default theme
#'
#' @param nlm_obj [\code{Raster* object}]
#' @param scale [\code{character}(1)]
#' Five options are available: "viridis - magma" (= "A"),
#'                             "viridis - inferno" (= "B"),
#'                             "viridis - plasma" (= "C"),
#'                             "viridis - viridis" (= "D", the default option),
#'                             and "greyscale" (= "E")
#'
#' @return visualization
#'
#' @examples
#' nlm_raster <- nlm_random(10,10)
#' util_plot(nlm_raster)
#'
#'
#' @aliases util_plot
#' @rdname util_plot
#'
#' @export
#'

util_plot <- function(nlm_obj, scale = "A") {

  if (scale == "E") {

    rasterVis::gplot(nlm_obj) +
      ggplot2::geom_raster(ggplot2::aes_string(fill = "value")) +
      ggplot2::coord_equal() +
      ggplot2::scale_fill_gradient(low = 'white', high = 'black') +
      ggplot2::labs(x = "Easting",
                    y = "Northing") +
      ggplot2::theme(
        legend.position = "bottom",
        text = ggplot2::element_text(color = "#22211d"),
        axis.line = ggplot2::element_line(),
        axis.ticks.length = ggplot2::unit(.15, "cm"),
        axis.ticks = ggplot2::element_line(),
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(), # bg of the panel
        plot.background = ggplot2::element_rect(fill = "transparent"), # bg of the plot
        panel.grid.major = ggplot2::element_blank(), # get rid of major grid
        panel.grid.minor = ggplot2::element_blank(), # get rid of minor grid
        legend.background = ggplot2::element_rect(fill = "transparent"), # get rid of legend bg
        legend.box.background = ggplot2::element_rect(fill = "transparent", color = NA), # get rid of legend panel bg
        strip.background = ggplot2::element_rect(colour = NA, fill = "grey45"),
        aspect.ratio=1
      ) +
      lemon::coord_capped_cart(
        xlim = c(0, 1), ylim = c(0, 1), left = "both", bottom = "both")


  } else {

    rasterVis::gplot(nlm_obj) +
      ggplot2::geom_raster(ggplot2::aes_string(fill = "value")) +
      ggplot2::coord_equal() +
      ggplot2::labs(x = "Easting",
                    y = "Northing") +
      ggplot2::theme(
        legend.position = "bottom",
        text = ggplot2::element_text(color = "#22211d"),
        axis.line = ggplot2::element_line(),
        axis.ticks.length = ggplot2::unit(.15, "cm"),
        axis.ticks = ggplot2::element_line(),
        panel.background = ggplot2::element_blank(),
        panel.border = ggplot2::element_blank(), # bg of the panel
        plot.background = ggplot2::element_rect(fill = "transparent"), # bg of the plot
        panel.grid.major = ggplot2::element_blank(), # get rid of major grid
        panel.grid.minor = ggplot2::element_blank(), # get rid of minor grid
        legend.background = ggplot2::element_rect(fill = "transparent"), # get rid of legend bg
        legend.box.background = ggplot2::element_rect(fill = "transparent", color = NA), # get rid of legend panel bg
        strip.background = ggplot2::element_rect(colour = NA, fill = "grey45"),
        aspect.ratio=1
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
        xlim = c(0, 1), ylim = c(0, 1), left = "both", bottom = "both")


  }

}

