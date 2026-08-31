#' nlm_edgegradient
#'
#' @description Simulates an edge-gradient neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param direction [\code{numerical(1)}]\cr
#' Direction of the gradient (between 0 and 360 degrees), if unspecified the
#' direction is randomly determined.
#' @param user_seed [\code{numerical(1)}]\cr
#' Set random seed for the simulation.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return SpatRaster
#'
#' @details
#' Simulates a linear gradient orientated on a specified or random direction
#' that has a central peak running perpendicular to the gradient direction.
#'
#' @examples
#'
#' # simulate random curdling
#' edge_gradient <- nlm_edgegradient(ncol = 100, nrow = 100, direction = 80)
#'
#' \dontrun{
#' # visualize the NLM
#' terra::plot(edge_gradient)
#' }
#'
#' @seealso \code{\link{nlm_distancegradient}},
#' \code{\link{nlm_planargradient}}
#'
#' @references
#' Travis, J.M.J. & Dytham, C. (2004) A method for simulating patterns of
#' habitat availability at static and dynamic range margins. \emph{Oikos}, 104,
#' 410–416.
#'
#' @aliases nlm_edgegradient
#' @rdname nlm_edgegradient
#'
#' @export
nlm_edgegradient <- function(ncol,
                             nrow,
                             resolution = 1,
                             direction = NA,
                             user_seed = NULL,
                             rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(direction)
  checkmate::assert_integerish(user_seed, len = 1, lower = 1, null.ok = TRUE)
  checkmate::assert_logical(rescale)

  if (!is.null(user_seed)) {
    set.seed(as.integer(user_seed))
  }

  # If direction was not set, give it a random value between 0 and 360 ---
  if (is.na(direction)) {
    direction <- stats::runif(1, 0, 360)
  }

  # Create planar gradient ----
  gradient_raster <- nlm_planargradient(ncol, nrow,
                                        resolution = resolution,
                                        direction =  direction,
                                        user_seed = user_seed)
  # Transform to a central gradient ----
  edgegradient_raster <-
    (abs(0.5 - gradient_raster) * -2) + 1

  # specify resolution ----
  terra::ext(edgegradient_raster) <- c(
    0,
    terra::ncol(edgegradient_raster) * resolution,
    0,
    terra::nrow(edgegradient_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    edgegradient_raster <- util_rescale(edgegradient_raster)
  }

  edgegradient_raster <- util_update_metadata(edgegradient_raster)

  return(edgegradient_raster)
}
