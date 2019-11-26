#' nlm_planargradient
#'
#' @description Simulates a planar gradient neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param direction [\code{numerical(1)}]\cr
#' Direction of the gradient in degrees, if unspecified the direction is randomly
#' determined.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @details
#' Simulates a linear gradient sloping in a specified or random direction.
#'
#' @examples
#' # simulate planar gradient
#' planar_gradient <- nlm_planargradient(ncol = 200, nrow = 200)
#'
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(planar_gradient)
#' }
#'
#' @seealso \code{\link{nlm_distancegradient}},
#' \code{\link{nlm_edgegradient}}
#'
#' @references
#' Palmer, M.W. (1992) The coexistence of species in fractal landscapes.
#' \emph{The American Naturalist}, 139, 375 - 397.
#'
#' @aliases nlm_planargradient
#' @rdname nlm_planargradient
#'
#' @export
#'


nlm_planargradient <- function(ncol,
                               nrow,
                               resolution = 1,
                               direction = NA,
                               rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(direction)
  checkmate::assert_logical(rescale)

  # If direction was not set, give it a random value between 0 and 360 ----
  if (is.na(direction)) {
    direction <- stats::runif(1, 0, 360)
  }

  # Determine the eastness and southness of the direction ----
  eastness <- sin( (pi / 180) * direction)
  southness <- cos( (pi / 180) * direction) * -1

  # Create arrays of row and column index ----
  col_index <- matrix(0:(ncol - 1), nrow, ncol, byrow = TRUE)
  row_index <- matrix(0:(nrow - 1), nrow, ncol, byrow = FALSE)

  # Create gradient matrix ----
  gradient_matrix <-
    (southness * row_index + eastness * col_index)

  # Transform to raster ----
  gradient_raster <- raster::raster(gradient_matrix)

  # specify resolution ----
  raster::extent(gradient_raster) <- c(
    0,
    ncol(gradient_raster) * resolution,
    0,
    nrow(gradient_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    gradient_raster <- util_rescale(gradient_raster)
  }

  return(gradient_raster)
}
