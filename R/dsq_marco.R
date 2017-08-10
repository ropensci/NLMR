#' Mid-point-displacement algorithm
#'
#' @param n Size of the landscape (2^n + 1)
#' @param roughness Degree of spatial autocorrelation
#'
#' @description
#'   \itemize{
#'   \item The diamond step: Taking a square of four points, generate a random value at the square midpoint, where the two diagonals meet. The midpoint value is calculated by averaging the four corner values, plus a random amount. This gives you diamonds when you have multiple squares arranged in a grid.
#'   \item The square step: Taking each diamond of four points, generate a random value at the center of the diamond. Calculate the midpoint value by averaging the corner values, plus a random amount generated in the same range as used for the diamond step. This gives you squares again.
#' }
#'
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' \dontrun{
#' marco_mpd(50, 50, 0.4)
#' }

marco_mpd <- function(n, roughness = 0.5){

  # The diamond-square algorithm begins with a 2D square array of width and
  # height 2n + 1
  size <- 2^n + 1

  # The size is then used to create a matrix, which has the xy-dims of size and
  # is used as input for the algorithm
  dsq_square <- matrix(0, nrow = size, ncol = size)

  #
  r <- stats::runif(1, min = 0, max = 0.5)

  # Main loop
  for (side.length in 2^(n:1)) {
    half.side <- side.length / 2

    # Square step
    for (col in seq(1, size - 1, by=side.length)) {
      for (row in seq(1, size - 1, by=side.length)) {
        avg <- mean(c(
          dsq_square[row, col],        # upper left
          dsq_square[row + side.length, col],  # lower left
          dsq_square[row, col + side.length],  # upper right
          dsq_square[row + side.length, col + side.length] #lower right
        ))
        avg <- avg + stats::rnorm(1, 0, r)

        dsq_square[row + half.side, col + half.side] <- avg
      }
    }

    # Diamond step
    for (row in seq(1, size, by=half.side)) {
      for (col in seq((col+half.side) %% side.length, size, side.length)) {

        avg <- mean(c(
          dsq_square[(row - half.side + size) %% size, col],# above
          dsq_square[(row + half.side) %% size, col], # below
          dsq_square[row, (col + half.side) %% size], # right
          dsq_square[row, (col - half.side) %% size]  # left
        ))
        dsq_square[row, col] <- avg + stats::rnorm(1, 0, r)

        if (row == 0) { dsq_square[size - 1, col] <- avg }
        if (col == 0) { dsq_square[row, size - 1] <- avg }
      }
    }

    r <- r * roughness

  }

  # reduces size of
  dsq_square <- dsq_square[-1,]
  dsq_square <- dsq_square[,-1]
  dsq_square <- dsq_square[,-max(ncol(dsq_square))]
  dsq_square <- dsq_square[-max(nrow(dsq_square)),]

  dsq_raster <- raster::raster(dsq_square)

  return(dsq_raster)

}

