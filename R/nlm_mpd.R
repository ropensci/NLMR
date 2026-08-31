#' nlm_mpd
#'
#' @description Simulates a midpoint displacement neutral landscape model.
#'
#' @details
#' The algorithm is a direct implementation of the midpoint displacement
#' algorithm.
#' It performs the following steps:
#'
#' \describe{
#'  \item{Initialization:}{Determine the smallest fit of
#'  \code{max(ncol, nrow)} in \emph{n^2 + 1} and assign value to n.
#'  Setup matrix of size (n^2 + 1)*(n^2 + 1).
#'  Afterwards, assign a random value to the four corners of the matrix.}
#'  \item{Square Step:}{For each square in the matrix, assign the average of
#'  the four corner points plus a random value to the midpoint of that square.}
#'  \item{Diamond Step:}{For each diamond in the matrix, assign the average
#'  of the four corner points plus a random value to the midpoint of that
#'  diamond.}
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
#' @param user_seed [\code{numerical(1)}]\cr
#' Set random seed for the simulation.
#' @param torus [\code{logical(1)}]\cr  Logical value indicating wether the algorithm should be simulated on a torus (default FALSE)
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#' @param verbose [\code{logical(1)}]\cr If \code{TRUE} (default), the user gets
#' a warning that the functions changes the dimensions to an appropriate one for
#' the algorithm.
#'
#' @return SpatRaster
#'
#' @references  \url{https://en.wikipedia.org/wiki/Diamond-square_algorithm}
#'
#' @examples
#'
#' # simulate midpoint displacement
#' midpoint_displacememt <- nlm_mpd(ncol = 100,
#'                                  nrow = 100,
#'                                  roughness = 0.3)
#'\dontrun{
#' # visualize the NLM
#' terra::plot(midpoint_displacememt)
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
                    user_seed = NULL,
                    torus = FALSE,
                    rescale = TRUE,
                    verbose = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution, lower = 0)
  checkmate::assert_number(roughness, lower = 0, upper = 1)
  checkmate::assert_integerish(user_seed, len = 1, lower = 1, null.ok = TRUE)
  checkmate::assert_logical(rescale)

  # create the landscape with rcpp_mpd ----
  seed <- if (is.null(user_seed)) sample.int(.Machine$integer.max, 1) else as.integer(user_seed)
  mpd_matrix <- rcpp_mpd(ncol + 1, nrow + 1, rand_dev, roughness, seed, torus)
  
  mpd_matrix <- mpd_matrix[-1, ]
  mpd_matrix <- mpd_matrix[, -1]
  mpd_matrix <- mpd_matrix[-nrow(mpd_matrix), ]
  mpd_matrix <- mpd_matrix[, -ncol(mpd_matrix)]
  
  # Convert matrix to raster ----
  mpd_raster <- terra::rast(mpd_matrix)

  # specify resolution ----
  terra::ext(mpd_raster) <- c(
    0,
    terra::ncol(mpd_raster) * resolution,
    0,
    terra::nrow(mpd_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    mpd_raster <- util_rescale(mpd_raster)
  }

  if (verbose == TRUE) {
    if (ncol %% 2 == 0 | nrow %% 2 == 0) {
      warning("nlm_mpd changes the dimensions of the SpatRaster if even ncols/nrows are chosen.")
    }
  }

  mpd_raster <- util_update_metadata(mpd_raster)

  return(mpd_raster)
}
