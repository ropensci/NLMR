#' nlm_mpd
#'
#' Create a midpoint displacement neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param roughness [\code{numerical(1)}]\cr Controls the level of spatial
#'          autocorrelation in element values.
#' @param rand_dev [\code{numerical(1)}]\cr Initial standard deviation for the displacement
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#'
#' @examples
#' nlm_mpd(nCol = 100, nRow = 100, roughness = 0.2)
#'
#'
#' @aliases nlm_mpd
#' @rdname nlm_mpd
#'
#' @export
#'

nlm_mpd  <-  function(nCol, nRow, roughness = 0.5,  rand_dev = NULL, rescale = TRUE){

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(roughness)
  checkmate::assert_true(roughness <= 1.0 || roughness >= 0)
  checkmate::assert_logical(rescale)

  # Init size of matrix (width and height 2n + 1) and the corresponding matrix
  max_dim <-  max(nRow, nCol)
  N      <- as.integer(ceiling(base::log(max_dim - 1, 2)))
  size    <-  2 ** N + 1

  mpd_raster <- matrix(0, nrow = size, ncol = size)

  # Init initial standard dev for the displacement (if not specified byt the user)
  if (missing(rand_dev)){
    rand_dev <- stats::runif(1, min = 0, max = 1)
  }


  # Main loop
  for (side.length in 2^(N:1)) {
    half.side <- side.length / 2

    # Square step
    for (col in seq(1, size - 1, by=side.length)) {
      for (row in seq(1, size - 1, by=side.length)) {
        avg <- mean(c(
          mpd_raster[row, col],                            # upper left
          mpd_raster[row + side.length, col],              # lower left
          mpd_raster[row, col + side.length],              # upper right
          mpd_raster[row + side.length, col + side.length] # lower right
        ))
        avg <- avg + stats::rnorm(1, 0, rand_dev)

        mpd_raster[row + half.side, col + half.side] <- avg
      }
    }

    # Diamond step
    for (row in seq(1, size, by=half.side)) {
      for (col in seq((col+half.side) %% side.length, size, side.length)) {

        avg <- mean(c(
          mpd_raster[(row - half.side + size) %% size, col],# above
          mpd_raster[(row + half.side) %% size, col],       # below
          mpd_raster[row, (col + half.side) %% size],       # right
          mpd_raster[row, (col - half.side) %% size]        # left
        ))
        mpd_raster[row, col] <- avg + stats::rnorm(1, 0, rand_dev)

        if (row == 0) { mpd_raster[size - 1, col] = avg }
        if (col == 0) { mpd_raster[row, size - 1] = avg }
      }
    }

    # Redudce value for displacement by roughness
    rand_dev <- rand_dev * roughness

  }

  # Remove artificial boundaries
  mpd_raster <- mpd_raster[-1,]
  mpd_raster <- mpd_raster[,-1]
  mpd_raster <- mpd_raster[,-max(ncol(mpd_raster))]
  mpd_raster <- mpd_raster[-max(nrow(mpd_raster)),]

  # Convert matrix to raster
  mpd_raster <- raster::raster(mpd_raster)


  # Rescale values to 0-1
  if (rescale == TRUE) {
    mpd_raster <- util_rescale(mpd_raster)
  }

  return(mpd_raster)

}

