#' distancegradientNLM
#'
#' @description Create a distance gradient neutral landscape model with values ranging 0-1.
#'
#' @details origin is a numeric vector of xmin, xmax, ymin, ymax for a square inside the raster from which the distance is measured.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param origin  [\code{numerical(4)}]\cr Edge coordinates of the origin of the distance measurement.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated.
#'
#' @return RasterLayer with distance measurements starting in a predefined origin.
#'
#'
#' @examples
#' distancegradientNLM(nCol = 100, nRow = 100, origin = c(20, 30, 10, 15))
#'
#' @aliases distancegradientNLM
#' @rdname distancegradientNLM
#'
#' @export
#'

distancegradientNLM <-
  function(nCol, nRow, origin, rescale = TRUE) {
    # raster::distance would produce an annyoing warning
    # because of a missing CRS
    suppressWarnings("In couldBeLonLat(x) : CRS is NA.
                     Assuming it is longitude/latitude")

    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_vector(origin, any.missing = FALSE)
    checkmate::assert_true(origin[2] <= nCol)
    checkmate::assert_true(origin[4] <= nRow)
    checkmate::assert_logical(rescale)

    # create empty raster ----
    distancegradient <-
      raster::raster(ncol = nCol, nrow = nRow, ext = raster::extent(c(0,1,0,1)))

    # set origin to 1 ----
    distancegradient[origin[1]:origin[2], origin[3]:origin[4]] <- 1

    # measure distance to origin ----
    suppressWarnings(distancegradient <-
                       raster::distance(distancegradient))

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      distancegradient <- rescaleNLM(distancegradient)
    }

    return(distancegradient)


  }
