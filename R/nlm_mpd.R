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
#' @param torus [\code{logical(1)}]\cr  Logical value indicating wether the algorithm should be simulated on a torus (default FALSE)
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
#'                                  roughness = 0.3)
#'\dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(midpoint_displacememt)
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
                    torus = FALSE,
                    rescale = TRUE,
                    verbose = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(roughness)
  checkmate::assert_true(roughness <= 1.0 || roughness >= 0)
  checkmate::assert_logical(rescale)

  # create the landscape with rcpp_mpd ----
  seed <- sample.int(.Machine$integer.max, 1)
  mpd_raster <- rcpp_mpd(ncol, nrow, rand_dev, roughness, seed, torus)
  
  mpd_raster <- mpd_raster[-1,]
  mpd_raster <- mpd_raster[,-1]
  mpd_raster <- mpd_raster[-nrow(mpd_raster),]
  mpd_raster <- mpd_raster[,-ncol(mpd_raster)]
  
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
    warning("nlm_mpd changes the dimensions of the RasterLayer if even ncols/nrows are choosen.")
  }

  return(mpd_raster)
}
