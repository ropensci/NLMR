#' nlm_mpd
#'
#' @description Simulates a midpoint displacement neutral landscape model.
#'
#' @details
#' The algorithm is a direct implementation of the midpoint displacement
#' algorithm.
#' It performs the following steps:
#'
#' \itemize{
#'  \item{Initialization: }{ Determine the smallest fit of
#'  \code{max(ncol, nrow)} in \emph{n^2 + 1} and assign value to n.
#'  Setup matrix of size (n^2 + 1)*(n^2 + 1).
#'  Afterwards, assign a random value to the four corners of the matrix.}
#'  \item{Diamond Step: }{ For each square in the matrix, assign the average of
#'  the four corner points plus a random value to the midpoint of that square.}
#'  \item{Diamond Step: }{ For each diamond in the matrix, assign the average
#'   of the four corner points plus a random value to the midpoint of that
#'   diamond.}
#' }
#'
#' At each iteration the roughness, an approximation to common Hurst exponent,
#' is reduced.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param roughness [\code{numerical(1)}]\cr
#' Controls the level of spatial autocorrelation (!= Hurst exponent)
#' @param rand_dev [\code{numerical(1)}]\cr
#' Initial standard deviation for the displacement step (default == 1), sets the
#' scale of the overall variance in the resulting landscape.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#' @param verbose [\code{logical(1)}]\cr If \code{TRUE} (default), the user gets
#' a warning that the functions changes the dimensions to an appropriate one for
#' the algorithm.
#'
#' @return RasterLayer
#'
#' @references  \url{https://en.wikipedia.org/wiki/Diamond-square_algorithm}
#'
#' @examples
#'
#' # simulate midpoint displacement
#' midpoint_displacememt <- nlm_mpd(ncol = 100,
#'                                  nrow = 100,
#'                                  roughness = 0.61)
#'\dontrun{
#' # visualize the NLM
#' landscapetools::util_plot(midpoint_displacememt)
#' }
#' @aliases nlm_mpd
#' @rdname nlm_mpd
#'
#' @export

nlm_mpd <- function(ncol,
                    nrow,
                    resolution = 1,
                    roughness = 0.5,
                    rand_dev = 1,
                    rescale = TRUE,
                    verbose = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(roughness)
  checkmate::assert_true(roughness <= 1.0 || roughness >= 0)
  checkmate::assert_logical(rescale)

  # Init size of matrix (width and height 2^n + 1) and the corresponding matrix
  max_dim <- max(nrow, ncol)
  N <- as.integer(ceiling(base::log(max_dim - 1, 2)))
  size <- 2 ** N + 1

  # setup matrix ----
  mpd_raster <- matrix(0, nrow = size, ncol = size)

  # Main loop  ----
  for (side.length in 2 ^ (N:1)) {
    half.side <- side.length / 2

    # Square step  ----
    for (col in seq(1, size - 1, by = side.length)) {
      for (row in seq(1, size - 1, by = side.length)) {
        avg <- mean(c(
          mpd_raster[row, col], # upper left
          mpd_raster[row + side.length, col], # lower left
          mpd_raster[row, col + side.length], # upper right
          mpd_raster[row + side.length, col + side.length] # lower right
        ))
        avg <- avg  + stats::rnorm(1, 0, rand_dev)

        mpd_raster[row + half.side, col + half.side] <- avg
      }
    }

    # Diamond step  ----
    for (row in seq(1, size, by = half.side)) {
      for (col in seq( (row + half.side) %% side.length, size, side.length)) {
        avg <- mean(c(
          mpd_raster[(row - half.side) %% size, col], # above
          mpd_raster[(row + half.side) %% size, col], # below
          mpd_raster[row, (col + half.side) %% size], # right
          mpd_raster[row, (col - half.side) %% size] # left
        ))
        mpd_raster[row, col] <- avg + stats::rnorm(1, 0, rand_dev)

        # if (row == 0) {
        #   mpd_raster[size - 1, col] <- avg
        # }
        # if (col == 0) {
        #   mpd_raster[row, size - 1] <- avg
        # }
      }
    }

    # Redudce value for displacement by roughness ----
    rand_dev <- rand_dev * roughness
  }

  # Convert matrix to raster ----
  mpd_raster <- raster::raster(mpd_raster)

  # specify resolution ----
  raster::extent(mpd_raster) <- c(
    0,
    ncol(mpd_raster) * resolution,
    0,
    nrow(mpd_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    mpd_raster <- util_rescale(mpd_raster)
  }

  if (verbose == TRUE) {
    message("nlm_mpd returns RasterLayer that fits in the dimension 2^n+1")
  }

  return(mpd_raster)
}
