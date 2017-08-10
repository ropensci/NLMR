#' randomRectangularClusterNLM
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param minL [\code{numerical(1)}]\cr The minimum possible length of width and height for each random rectangular cluster.
#' @param maxL [\code{numerical(1)}]\cr The maximum possible length of width and height for each random rectangular cluster.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#'
#' @examples
#' randomRectangularClusterNLM(nCol = 100, nRow = 100, minL = 5, maxL = 40)
#'
#'
#' @aliases randomRectangularClusterNLM
#' @rdname randomRectangularClusterNLM
#'
#' @export
#'

randomRectangularClusterNLM <-
  function(nCol, nRow, minL, maxL, rescale = TRUE) {
    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_count(minL, positive = TRUE)
    checkmate::assert_count(maxL, positive = TRUE)
    checkmate::assert_true(minL <= nCol)
    checkmate::assert_true(minL <= nRow)
    checkmate::assert_true(maxL <= nCol)
    checkmate::assert_true(maxL <= nRow)
    checkmate::assert_logical(rescale)

    # Create an empty matrix of correct dimensions ----
    matrix  <-  matrix(NA, nCol, nRow)

    # Keep applying random clusters until all elements have a value -----
    while (any(is.na(matrix))) {
      width <- sample(c(minL:maxL), 1)
      height <- sample(c(minL:maxL), 1)

      row <- sample(c(1:nRow), 1)
      col <- sample(c(1:nCol), 1)

      matrix[if ((row + width) < nRow)
        row:(row + width)
        else
          row:nRow,
        if ((col + height) < nCol)
          col:(col + height)
        else
          col:nCol] <- stats::runif(1, 0, 1)

    }

    # Transform to raster ----
    randomrectangularcluster_raster <- raster::raster(matrix)

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomrectangularcluster_raster <-
        rescaleNLM(randomrectangularcluster_raster)
    }

    return(randomrectangularcluster_raster)

  }
