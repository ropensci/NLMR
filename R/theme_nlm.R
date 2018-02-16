#' theme_nlm
#'
#' @description Opinionated ggplot2 theme to visualize NLM raster.
#'
#' @param base_family [\code{character}()]  base font family size
#' @param base_size [\code{numeric}(1)] base font size
#' @param plot_title_family [\code{character}()] plot title family
#' @param plot_title_face [\code{character}()] plot title face
#' @param plot_title_size [\code{character}()] plot title size
#' @param plot_title_margin [\code{numeric}(1)] plot title margin
#' @param plot_margin [\code{character}()]
#' plot margin (specify with \code{ggplot2::margin})
#' @param subtitle_family [\code{character}()] plot subtitle family
#' @param subtitle_face [\code{character}()]` plot subtitle face
#' @param subtitle_size [\code{numeric}(1)] plot subtitle size
#' @param subtitle_margin [\code{numeric}(1)]
#' plot subtitle margin bottom (single numeric value)
#' @param strip_text_family [\code{character}()] facet facet label font family
#' @param strip_text_face [\code{character}()] facet facet label font face
#' @param strip_text_size [\code{numeric}(1)]
#' facet label font family, face and size
#' @param caption_family [\code{character}()] plot caption family
#' @param caption_face [\code{character}()] plot caption face
#' @param caption_size [\code{numeric}(1)] plot caption size
#' @param caption_margin [\code{numeric}(1)] plot caption margin
#' @param legend_title [\code{character}()] Title of the legend (default "Z")
#' @param legend_labels [\code{character}()] Labels for the legend ticks, if
#' used with \code{\link{util_plot}} they are automatically derived.
#' @param ratio [\code{character}()]
#' ratio for tiles (default 1, if your raster is not a square the ratio should
#' be \code{raster::nrow(x) / raster::ncol(x)})
#' @param viridis_scale [\code{character}(1)]
#' Five options are available: "viridis - magma" (= "A"),
#'                             "viridis - inferno" (= "B"),
#'                             "viridis - plasma" (= "C"),
#'                             "viridis - viridis" (= "D",  the default option)
#'
#' @details
#' A focused theme to visualize raster data that sets a lot of defaults for the
#' \code{ggplot2::theme}.
#'
#' The theme can make use of the Roboto Condensed font (Open Source font from
#' Google).
#' If your local font library does not contain Roboto as a font, you can
#' import it via \code{\link{util_import_roboto_condensed}} (highly recommended).
#'
#' The functions are setup in such a way that you can customize your own one by
#' just wrapping the call and changing the parameters.
#' The theme itself is heavily influenced by hrbrmstr and his package
#' hrbrthemes (\url{https://github.com/hrbrmstr/hrbrthemes/}).
#'
#' @seealso \code{\link{util_import_roboto_condensed}}
#'
#' @examples
#' # nolint start
#' \dontrun{
#' # simulate NLM
#' x <- nlm_random(ncol = 75,
#'                 nrow = 75)
#' # classify
#' y <- c(0.5, 0.15, 0.25)
#' y <- util_classify(x, y, c("1", "2", "3"))
#'
#' # color + continuous
#' rasterVis::gplot(x) +
#'   ggplot2::geom_tile(ggplot2::aes(fill = value)) +
#'   ggplot2::labs(x = "Easting",
#'                 y = "Northing") +
#'   theme_nlm() +
#'   ggplot2::ggtitle("Random NLM with continuous viridis color scale",
#'                    subtitle = "75x75 cells") +
#'   ggplot2::labs(caption = "Random map simulated with the R package NLMR.")
#'
#' # grey + continuous
#' rasterVis::gplot(x) +
#'   ggplot2::geom_tile(ggplot2::aes(fill = value)) +
#'   ggplot2::labs(x = "Easting",
#'                 y = "Northing") +
#'   theme_nlm_grey() +
#'   ggplot2::ggtitle("Random NLM with continuous grey color scale",
#'                    subtitle = "75x75 cells") +
#'   ggplot2::labs(caption = "Random map simulated with the R package NLMR.")
#'
#' # color + discrete
#' rasterVis::gplot(y) +
#'   ggplot2::geom_tile(ggplot2::aes(fill = factor(value))) +
#'   ggplot2::labs(x = "Easting",
#'                 y = "Northing") +
#'   theme_nlm_discrete() +
#'   ggplot2::ggtitle("Random NLM with discrete viridis color scale",
#'                    subtitle = "75x75 cells") +
#'   ggplot2::labs(caption = "Random map simulated with the R package NLMR.")
#'
#' # grey + discrete
#' rasterVis::gplot(y) +
#'   ggplot2::geom_tile(ggplot2::aes(fill = factor(value))) +
#'   ggplot2::labs(x = "Easting",
#'                 y = "Northing") +
#'   theme_nlm_grey_discrete() +
#'   ggplot2::ggtitle("Random NLM with discrete grey color scale",
#'                    subtitle = "75x75 cells") +
#'   ggplot2::labs(caption = "Random map simulated with the R package NLMR.")
#' # nolint end
#' }
#'
#' @aliases theme_nlm
#' @rdname theme_nlm
#' @name theme_nlm
#'
NULL

#' @rdname theme_nlm
#' @export
theme_nlm <- function(base_family = "serif",
                      base_size = 11.5,
                      plot_title_family = "serif",
                      plot_title_size = 18,
                      plot_title_face = "bold",
                      plot_title_margin = 10,
                      subtitle_family = "serif",
                      subtitle_size = 13,
                      subtitle_face = "plain",
                      subtitle_margin = 15,
                      strip_text_family = base_family,
                      strip_text_size = 12,
                      strip_text_face = "plain",
                      caption_family = "serif",
                      caption_size = 9,
                      caption_face = "plain",
                      caption_margin = 10,
                      legend_title = "Z",
                      plot_margin = ggplot2::margin(30, 30, 30, 30),
                      ratio = 1,
                      viridis_scale = "D") {
  # start with minimal theme
  ret <-
    ggplot2::theme_minimal(base_family = base_family, base_size = base_size)

  # extend it
  theme_base <- ret + ggplot2::theme(
    legend.background = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = 8),
    aspect.ratio = ratio,
    plot.margin = plot_margin,
    strip.text = ggplot2::element_text(
      hjust = 0,
      size = strip_text_size,
      face = strip_text_face,
      family = strip_text_family
    ),
    panel.spacing = grid::unit(2, "lines"),
    plot.title = ggplot2::element_text(
      hjust = 0,
      size = plot_title_size,
      margin = ggplot2::margin(b = plot_title_margin),
      family = plot_title_family,
      face = plot_title_face
    ),
    plot.subtitle = ggplot2::element_text(
      hjust = 0,
      size = subtitle_size,
      margin = ggplot2::margin(b = subtitle_margin),
      family = subtitle_family,
      face = subtitle_face
    ),
    plot.caption = ggplot2::element_text(
      hjust = 1,
      size = caption_size,
      margin = ggplot2::margin(t = caption_margin),
      family = caption_family,
      face = caption_face
    )
  )

  # define color scale
  theme_color <- viridis::scale_fill_viridis(
    option = viridis_scale,
    direction = 1,
    na.value = "transparent",
    name = legend_title,
    guide = ggplot2::guide_colorbar(
      barheight = ggplot2::unit(40, units = "mm"),
      barwidth = ggplot2::unit(1, units = "mm"),
      draw.ulim = FALSE,
      title.hjust = 0.5,
      title.vjust = 1.5,
      label.hjust = 0.5
    )
  )

  # return as list
  list(theme_base,
       theme_color)

}

#' @rdname theme_nlm
#' @export
theme_nlm_discrete <- function(
  base_family = "serif",
  base_size = 11.5,
  plot_title_family = base_family,
  plot_title_size = 18,
  plot_title_face = "bold",
  plot_title_margin = 10,
  subtitle_family = "serif",
  subtitle_size = 13,
  subtitle_face = "plain",
  subtitle_margin = 15,
  strip_text_family = base_family,
  strip_text_size = 12,
  strip_text_face = "plain",
  caption_family = "serif",
  caption_size = 9,
  caption_face = "plain",
  caption_margin = 10,
  legend_title = "Z",
  legend_labels = NULL,
  plot_margin = ggplot2::margin(30, 30, 30, 30),
  ratio = 1,
  viridis_scale = "D") {
  # start with minimal theme
  ret <-
    ggplot2::theme_minimal(base_family = base_family, base_size = base_size)

  # extend it
  theme_base <- ret + ggplot2::theme(
    legend.background = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = 8),
    aspect.ratio = ratio,
    plot.margin = plot_margin,
    strip.text = ggplot2::element_text(
      hjust = 0,
      size = strip_text_size,
      face = strip_text_face,
      family = strip_text_family
    ),
    panel.spacing = grid::unit(2, "lines"),
    plot.title = ggplot2::element_text(
      hjust = 0,
      size = plot_title_size,
      margin = ggplot2::margin(b = plot_title_margin),
      family = plot_title_family,
      face = plot_title_face
    ),
    plot.subtitle = ggplot2::element_text(
      hjust = 0,
      size = subtitle_size,
      margin = ggplot2::margin(b = subtitle_margin),
      family = subtitle_family,
      face = subtitle_face
    ),
    plot.caption = ggplot2::element_text(
      hjust = 1,
      size = caption_size,
      margin = ggplot2::margin(t = caption_margin),
      family = caption_family,
      face = caption_face
    )
  )

  # define color scale
  theme_color <- viridis::scale_fill_viridis(
    option = viridis_scale,
    direction = 1,
    discrete = TRUE,
    na.value = "transparent",
    labels = if (is.null(legend_labels)) {
      ggplot2::waiver()
    } else {
      legend_labels
    },
    name = legend_title,
    guide = ggplot2::guide_legend(
      barheight = ggplot2::unit(40, units = "mm"),
      barwidth = ggplot2::unit(1, units = "mm"),
      draw.ulim = FALSE,
      title.hjust = 0.5,
      title.vjust = 1.5,
      label.hjust = 0.5
    )
  )

  # return as list
  list(theme_base,
       theme_color)

}

#' @rdname theme_nlm
#' @export
theme_nlm_grey <- function(base_family = "serif",
                           base_size = 11.5,
                           plot_title_family = base_family,
                           plot_title_size = 18,
                           plot_title_face = "bold",
                           plot_title_margin = 10,
                           subtitle_family = "serif",
                           subtitle_size = 13,
                           subtitle_face = "plain",
                           subtitle_margin = 15,
                           strip_text_family = base_family,
                           strip_text_size = 12,
                           strip_text_face = "plain",
                           caption_family = "serif",
                           caption_size = 9,
                           caption_face = "plain",
                           caption_margin = 10,
                           legend_title = "Z",
                           plot_margin = ggplot2::margin(30, 30, 30, 30),
                           ratio = 1,
                           viridis_scale = "D") {
  # start with minimal theme
  ret <-
    ggplot2::theme_minimal(base_family = base_family, base_size = base_size)

  # extend it
  theme_base <- ret + ggplot2::theme(
    legend.background = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(size = 8),
    aspect.ratio = ratio,
    plot.margin = plot_margin,
    strip.text = ggplot2::element_text(
      hjust = 0,
      size = strip_text_size,
      face = strip_text_face,
      family = strip_text_family
    ),
    panel.spacing = grid::unit(2, "lines"),
    plot.title = ggplot2::element_text(
      hjust = 0,
      size = plot_title_size,
      margin = ggplot2::margin(b = plot_title_margin),
      family = plot_title_family,
      face = plot_title_face
    ),
    plot.subtitle = ggplot2::element_text(
      hjust = 0,
      size = subtitle_size,
      margin = ggplot2::margin(b = subtitle_margin),
      family = subtitle_family,
      face = subtitle_face
    ),
    plot.caption = ggplot2::element_text(
      hjust = 1,
      size = caption_size,
      margin = ggplot2::margin(t = caption_margin),
      family = caption_family,
      face = caption_face
    )
  )

  # define color scale
  theme_color <- ggplot2::scale_fill_gradient(
    low = "#d0d0d0",
    high = "#000000",
    na.value = "transparent",
    name = legend_title,
    guide = ggplot2::guide_colorbar(
      barheight = ggplot2::unit(40, units = "mm"),
      barwidth = ggplot2::unit(1, units = "mm"),
      draw.ulim = FALSE,
      title.hjust = 0.5,
      title.vjust = 1.5,
      label.hjust = 0.5
    )
  )

  # return as list
  list(theme_base,
       theme_color)

}

#' @rdname theme_nlm
#' @export
theme_nlm_grey_discrete <-
  function(base_family = "serif",
           base_size = 11.5,
           plot_title_family = base_family,
           plot_title_size = 18,
           plot_title_face = "bold",
           plot_title_margin = 10,
           subtitle_family = "serif",
           subtitle_size = 13,
           subtitle_face = "plain",
           subtitle_margin = 15,
           strip_text_family = base_family,
           strip_text_size = 12,
           strip_text_face = "plain",
           caption_family = "serif",
           caption_size = 9,
           caption_face = "plain",
           caption_margin = 10,
           legend_title = "Z",
           legend_labels = NULL,
           plot_margin = ggplot2::margin(30, 30, 30, 30),
           ratio = 1,
           viridis_scale = "D") {
    # start with minimal theme
    ret <-
      ggplot2::theme_minimal(base_family = base_family, base_size = base_size)

    # extend it
    theme_base <- ret + ggplot2::theme(
      legend.background = ggplot2::element_blank(),
      legend.text = ggplot2::element_text(size = 8),
      aspect.ratio = ratio,
      plot.margin = plot_margin,
      strip.text = ggplot2::element_text(
        hjust = 0,
        size = strip_text_size,
        face = strip_text_face,
        family = strip_text_family
      ),
      panel.spacing = grid::unit(2, "lines"),
      plot.title = ggplot2::element_text(
        hjust = 0,
        size = plot_title_size,
        margin = ggplot2::margin(b = plot_title_margin),
        family = plot_title_family,
        face = plot_title_face
      ),
      plot.subtitle = ggplot2::element_text(
        hjust = 0,
        size = subtitle_size,
        margin = ggplot2::margin(b = subtitle_margin),
        family = subtitle_family,
        face = subtitle_face
      ),
      plot.caption = ggplot2::element_text(
        hjust = 1,
        size = caption_size,
        margin = ggplot2::margin(t = caption_margin),
        family = caption_family,
        face = caption_face
      )
    )

    # define color scale
    theme_color <- ggplot2::scale_fill_brewer(
      palette = "Greys",
      na.value = "transparent",
      name = legend_title,
      labels = if (is.null(legend_labels)) {
        ggplot2::waiver()
      } else {
        legend_labels
      },
      guide = ggplot2::guide_legend(
        barheight = ggplot2::unit(40, units = "mm"),
        barwidth = ggplot2::unit(1, units = "mm"),
        draw.ulim = FALSE,
        title.hjust = 0.5,
        title.vjust = 1.5,
        label.hjust = 0.5
      )
    )

    # return as list
    list(theme_base,
         theme_color)

  }
