#' nlm_randomrectangularcluster
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param ncol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr Resolution of the raster.
#' @param minL [\code{numerical(1)}]\cr The minimum possible width and height for each random rectangular cluster.
#' @param maxL [\code{numerical(1)}]\cr The maximum possible width and height for each random rectangular cluster.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#'
#' @examples
#' # simulate random rectangular cluster
#' randomrectangular_cluster <- nlm_randomrectangularcluster(ncol = 30,
#'                                                           nrow = 30,
#'                                                           minL = 5,
#'                                                           maxL = 10)
#' \dontrun{
#' # visualize the NLM
#' util_plot(randomrectangular_cluster)
#' }
#'
#' @aliases nlm_randomrectangularcluster
#' @rdname nlm_randomrectangularcluster
#'
#' @export
#'

nlm_randomrectangularcluster <-
  function(ncol,
           nrow,
           resolution = 1,
           minL,
           maxL,
           rescale = TRUE) {
    # Check function arguments ----
    checkmate::assert_count(ncol, positive = TRUE)
    checkmate::assert_count(nrow, positive = TRUE)
    checkmate::assert_numeric(resolution)
    checkmate::assert_count(minL, positive = TRUE)
    checkmate::assert_count(maxL, positive = TRUE)
    checkmate::assert_true(minL <= ncol)
    checkmate::assert_true(minL <= nrow)
    checkmate::assert_true(maxL <= ncol)
    checkmate::assert_true(maxL <= nrow)
    checkmate::assert_logical(rescale)

    # Create an empty matrix of correct dimensions ----
    matrix <- matrix(NA, ncol, nrow)

    # Keep applying random clusters until all elements have a value -----
    while (any(is.na(matrix))) {
      width <- sample(minL:maxL, 1)
      height <- sample(minL:maxL, 1)

      row <- sample(1:nrow, 1)
      col <- sample(1:ncol, 1)

      matrix[
        if ((row + width) < nrow) {
          row:(row + width)
        } else {
          row:nrow
        },
        if ((col + height) < ncol) {
          col:(col + height)
        } else {
          col:ncol
        }
      ] <- stats::runif(1, 0, 1)
    }

    # Transform to raster ----
    randomrectangularcluster_raster <- raster::raster(matrix)

    # specify resolution ----
    raster::extent(randomrectangularcluster_raster) <- c(
      0,
      ncol(randomrectangularcluster_raster) * resolution,
      0,
      nrow(randomrectangularcluster_raster) * resolution
    )

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomrectangularcluster_raster <-
        util_rescale(randomrectangularcluster_raster)
    }

    return(randomrectangularcluster_raster)
  }


##### Falling leaves algorithm?
