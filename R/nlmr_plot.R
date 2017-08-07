#' Method nlmr_plot
#' @name nlmr_plot-method
#' @rdname nlmr_plot-method
#' @exportMethod nlmr_plot

setGeneric("nlmr_plot", function(nlm_obj) {
  standardGeneric("nlmr_plot")
})


#' nlmr_plot
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nlm_obj Raster* object
#'
#' @return rasterVis visualization
#'
#'
#' @examples
#' \dontrun{
#' nlmr_plot(nlm_obj)
#' }
#'
#' @aliases nlmr_plot
#' @rdname nlmr_plot-method
#'
#' @export
#'


setMethod(
  "nlmr_plot",
  signature = signature("RasterLayer"),
  definition = function(nlm_obj){

    rasterVis::gplot(nlm_obj) +
      ggplot2::geom_raster(ggplot2::aes(fill = value)) +
      ggthemes::geom_rangeframe(data=data.frame(x=c(nlm_obj@extent@xmin, nlm_obj@extent@xmax), y=c(nlm_obj@extent@ymin, nlm_obj@extent@ymax)), ggplot2::aes(x, y)) +
      ggplot2::coord_equal() +
      ggplot2::labs(x = "Easting",
                    y = "Northing") +
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "bottom",
                     text = ggplot2::element_text(family = "Roboto", color = "#22211d"),
                     axis.line = ggplot2::element_blank(),
                     axis.ticks.length = ggplot2::unit(.15, "cm"),
                     axis.ticks = ggplot2::element_line(),
                     panel.grid.major = ggplot2::element_blank(),
                     panel.grid.minor = ggplot2::element_blank(),
                     panel.border = ggplot2::element_blank()) +
      viridis::scale_fill_viridis(
        option = "D",
        direction = -1,
        na.value = "transparent",
        name = "Z",
        guide = ggplot2::guide_colorbar(
          direction = "horizontal",
          barheight = ggplot2::unit(2, units = "mm"),
          barwidth = ggplot2::unit(50, units = "mm"),
          draw.ulim = F,
          title.position = 'top',
          title.hjust = 0.5,
          label.hjust = 0.5
        ))


  }
)
