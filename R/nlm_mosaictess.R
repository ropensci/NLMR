#' nlm_mosaictess
#'
#' @description Simulate the NLM introduced in Gaucherel (2008).
#'
#' @details
#' \code{nlm_mosaictess} offers the first option of simulating a neutral landscape model
#' described in Gaucherel (2008). It generates a random point pattern (the germs)
#' with an independent distribution and uses the voronoi tessellation to simulate
#' the mosaic landscapes.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param germs [\code{numerical(1)}]\cr
#' Intensity parameter (non-negative integer).
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate polygonal landscapes
#' mosaictess <- nlm_mosaictess(ncol = 30, nrow = 30, germs = 20)
#'
#' \dontrun{
#' # visualize the NLM
#' util_plot(poly_lands)
#' }
#'
#' @references
#' Gaucherel, C. (2008) Neutral models for polygonal landscapes with linear
#' networks. \emph{Ecological Modelling}, 219, 39 - 48.
#'
#' @aliases nlm_polylands
#' @rdname nlm_polylands
#'
#' @export
#'

nlm_mosaictess <- function(ncol,
                            nrow,
                            resolution = 1,
                            germs) {
  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(germs)

  # generate the germs from which the polygons are build ----
  X <- spatstat::runifpoint(germs)

  # compute the Dirichlet tessellation ----
  tess_surface <- spatstat::dirichlet(X)

  # whole bunch of conversions to get a raster in the end ----
  tess_im <- spatstat::as.im(tess_surface, dimyx = c(nrow, ncol))
  tess_data <- raster::as.data.frame(tess_im)
  sp::coordinates(tess_data) <- ~ x + y
  sp::gridded(tess_data) <- TRUE
  polylands_raster <- raster::deratify(raster::raster(tess_data))
  polylands_raster <- raster::crop(polylands_raster,
                                   raster::extent(0, 1, 0, 1))

  # specify resolution ----
  raster::extent(polylands_raster) <- c(0,
                                        ncol(polylands_raster) * resolution,
                                        0,
                                        nrow(polylands_raster) * resolution)
  return(polylands_raster)
}
