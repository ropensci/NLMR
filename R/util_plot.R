#' util_plot
#'
#' Plot a Raster* object with the NLMR default theme
#'
#' @param x [\code{Raster* object}]
#' @param discrete [\code{logical}(1)] If TRUE, the function plots a raster with
#' a discrete legend.
#' @param ... Arguments for  \code{\link{theme_nlm}}
#'
#' @return ggplot2 Object
#'
#' @examples
#' \dontrun{
#' # simulate NLM
#' x <- NLMR::nlm_random(ncol = 25,
#'                       nrow = 75)
#' # classify
#' y <- c(0.5, 0.15, 0.25)
#' y <- util_classify(x, y, c("1", "2", "3"))
#'
#' util_plot(x)
#' util_plot(y, discrete = TRUE)
#'
#' util_plot_grey(x)
#' util_plot_grey(y, discrete = TRUE)
#'
#' }
#'
#' @aliases util_plot
#' @rdname util_plot
#' @name util_plot
#'
NULL

#' @rdname util_plot
#' @export
util_plot <- function(x,
                      discrete = FALSE,
                      ...) {
  # derive ratio for plot, cells should be a square and axis equal in length
  if (raster::ncol(x) == raster::nrow(x)) {
    ratio <- 1
  } else {
    ratio <- raster::nrow(x) / raster::ncol(x)
  }

  if (raster::nlayers(x) == 1) {
    if (isTRUE(discrete)) {
      # get rasterlabels
      legend_labels <- tryCatch({
        x@data@attributes[[1]][, 2]
      },
      error = function(e) {
        x <- raster::as.factor(x)
        levels <- raster::unique(x)
        x@data@attributes[[1]][, 2] <- levels
      })

      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = factor(value))) +
        ggplot2::labs(x = "Easting",
                      y = "Northing")  +
        theme_nlm_discrete(..., legend_labels = legend_labels, ratio = ratio)

    } else {
      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = value)) +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +
        theme_nlm(..., ratio = ratio)
    }
  } else {
    rasterVis::levelplot(x)
  }
}


#' @rdname util_plot
#' @export
util_plot_grey <- function(x,
                           discrete = FALSE,
                           ...) {
  # derive ratio for plot, cells should be a square and axis equal in length
  if (raster::ncol(x) == raster::nrow(x)) {
    ratio <- 1
  } else {
    ratio <- raster::nrow(x) / raster::ncol(x)
  }

  if (raster::nlayers(x) == 1) {
    if (isTRUE(discrete)) {
      # discrete case

      # get rasterlabels
      legend_labels <- tryCatch({
        x@data@attributes[[1]][, 2]
      },
      error = function(e) {
        x <- raster::as.factor(x)
        levels <- raster::unique(x)
        x@data@attributes[[1]][, 2] <- levels
      })

      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = factor(value))) +
        ggplot2::labs(x = "Easting",
                      y = "Northing")  +
        theme_nlm_grey_discrete(...,
                                legend_labels = legend_labels,
                                ratio = ratio)

    } else {
      rasterVis::gplot(x) +
        ggplot2::geom_raster(ggplot2::aes(fill = value)) +
        ggplot2::labs(x = "Easting",
                      y = "Northing") +
        theme_nlm_grey(..., ratio = ratio)
    }
  } else {
    rasterVis::levelplot(x)
  }
}
