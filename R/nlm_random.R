#' nlm_random
#'
#' @description Simulates a spatially random neutral landscape model with values
#' drawn a uniform distribution.
#'
#' @details
#' The function takes the number of columns and rows as input and creates a
#' SpatRaster with the same extent. Each raster cell is randomly assigned a
#' value between 0 and 1 drawn from an uniform distribution (\code{runif(1,0,1)}).
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param user_seed [\code{numerical(1)}]\cr
#' Set random seed for the simulation.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return SpatRaster
#'
#' @examples
#' # simulate spatially random model
#' random <- nlm_random(ncol = 200, nrow = 100)
#'
#' \dontrun{
#' # visualize the NLM
#' terra::plot(random)
#' }
#'
#' @aliases nlm_random
#' @rdname nlm_random
#'
#' @export
nlm_random <- function(ncol,
                       nrow,
                       resolution = 1,
                       user_seed = NULL,
                       rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_integerish(user_seed, len = 1, lower = 1, null.ok = TRUE)
  checkmate::assert_logical(rescale)

  if (!is.null(user_seed)) {
    set.seed(as.integer(user_seed))
  }

  # Assign random values to raster cells ----
  random_raster <-
    terra::rast(matrix(stats::runif(ncol * nrow, 0, 1), nrow, ncol))

  # specify resolution ----
  terra::ext(random_raster) <- c(
    0,
    ncol(random_raster) * resolution,
    0,
    nrow(random_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    random_raster <- util_rescale(random_raster)
  }

  random_raster <- util_update_metadata(random_raster)

  return(random_raster)
}
