#' nlm_randomrectangularcluster
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr Resolution of the raster.
#' @param minL [\code{numerical(1)}]\cr The minimum possible width and height for each random rectangular cluster.
#' @param maxL [\code{numerical(1)}]\cr The maximum possible width and height for each random rectangular cluster.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#'
#' @examples
#' nlm_randomrectangularcluster(nCol = 100, nRow = 100, minL = 5, maxL = 40)
#'
#'
#' @aliases nlm_randomrectangularcluster
#' @rdname nlm_randomrectangularcluster
#'
#' @export
#'

nlm_randomrectangularcluster <-
  function(nCol,
           nRow,
           resolution = 1,
           minL,
           maxL,
           rescale = TRUE) {
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

      matrix[if ( (row + width) < nRow)
        row:(row + width)
        else
          row:nRow,
        if ( (col + height) < nCol)
          col:(col + height)
        else
          col:nCol] <- stats::runif(1, 0, 1)

    }

    # Transform to raster ----
    randomrectangularcluster_raster <- raster::raster(matrix)

    # specify resolution ----
    raster::extent(randomrectangularcluster_raster) <- c(0,
                                         ncol(randomrectangularcluster_raster)*resolution,
                                         0,
                                         nrow(randomrectangularcluster_raster)*resolution)

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomrectangularcluster_raster <-
        util_rescale(randomrectangularcluster_raster)
    }

    return(randomrectangularcluster_raster)

  }


##### Falling leaves algorithm? googlen or ask katrin
