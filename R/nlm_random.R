#' nlm_random
#'
#' @description Simulates a spatially random neutral landscape model with values
#' drawn a uniform distribution.
#'
#' @details
#' The function takes the number of columns and rows as input and creates a
#' RasterLayer with the same extent. Each raster cell is randomly assigned a
#' value between 0 and 1 drawn from an uniform distribution (\code{runif(1,0,1)}).
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate spatially random model
#' random <- nlm_random(ncol = 200, nrow = 100)
#'
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(random)
#' }
#'
#' @aliases nlm_random
#' @rdname nlm_random
#'
#' @export
#'

nlm_random <- function(ncol,
                       nrow,
                       resolution = 1,
                       rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_logical(rescale)

  # Assign random values to raster cells ----
  random_raster <-
    raster::raster(matrix(stats::runif(ncol * nrow, 0, 1), nrow, ncol))

  # specify resolution ----
  raster::extent(random_raster) <- c(
    0,
    ncol(random_raster) * resolution,
    0,
    nrow(random_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    random_raster <- util_rescale(random_raster)
  }

  return(random_raster)
}
