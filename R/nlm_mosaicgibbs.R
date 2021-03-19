#' nlm_mosaicgibbs
#'
#' @description Simulate a neutral landscape model using the Gibbs algorithm introduced in Gaucherel (2008).
#'
#' @details
#' \code{nlm_mosaicgibbs} offers the second option of simulating a neutral landscape model
#' described in Gaucherel (2008).
#' The method works in principal like the tessellation method (\code{nlm_mosaictess}),
#' but instead of a random point pattern the algorithm fits a simulated realization of the Strauss
#' process. The Strauss process starts with a given number of points and
#' uses a minimization approach to fit a point pattern with a given interaction
#' parameter (0 - hardcore process; 1 - Poisson process) and interaction radius
#' (distance of points/germs being apart).
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param germs [\code{numerical(1)}]\cr
#' Intensity parameter (non-negative integer).
#' @param R [\code{numerical(1)}]\cr
#' Interaction radius (non-negative integer) for the fitting of the spatial point
#' pattern process - the min. distance between germs in map units.
#' @param patch_classes [\code{numerical(1)}]\cr
#' Number of classes for germs.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#' @return RasterLayer
#'
#' @examples
#' # simulate polygonal landscapes
#' mosaicgibbs <- nlm_mosaicgibbs(ncol = 40,
#'                               nrow = 30,
#'                               germs = 20,
#'                               R = 0.02,
#'                               patch_classes = 12)
#'
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(mosaicgibbs)
#' }
#'
#' @references
#' Gaucherel, C. (2008) Neutral models for polygonal landscapes with linear
#' networks. \emph{Ecological Modelling}, 219, 39 - 48.
#'
#' @aliases nlm_mosaicgibbs
#' @rdname nlm_mosaicgibbs
#'
#' @export
#'

nlm_mosaicgibbs <- function(ncol,
                            nrow,
                            resolution = 1,
                            germs,
                            R,
                            patch_classes,
                            rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(germs)
  checkmate::assert_numeric(R)
  checkmate::assert_count(patch_classes, positive = TRUE)
  checkmate::assert_logical(rescale)

  # create point pattern (germs); step 2 in section 2.2 of Gauchel 2008
  x <- spatstat.core::rSSI(R, germs, win = spatstat.geom::owin(c(0, ncol), c(0, nrow)))

  # ... and randomly allocate attribute class (here point pattern mark)
  m <- sample(rep(1:patch_classes, length.out = germs))
  spatstat.geom::marks(x) <- m

  # Coerce to SpatialPointsDataFrame to preserve marks for interpolation ----
  strauss_points <- sf::st_as_sf(data.frame(x), coords = c("x", "y"))

  # compute the voronoi tessellation and clip
  voronoi_tess <-
    sf::st_voronoi(sf::st_union(strauss_points), dTolerance = 0.1)
  voronoi_tess <-
    sf::st_intersection(sf::st_buffer(sf::st_cast(voronoi_tess), 0),
                        sf::st_as_sfc(sf::st_bbox(sf::st_as_sf(
                          data.frame(x = c(0, ncol),
                                     y = c(0, nrow)),
                                     coords = c("x", "y")
                        ))))
  voronoi_tess <-
    sf::st_sf(
      value = strauss_points$marks,
      geometry = sf::st_sfc(voronoi_tess)
    )

  # (f)rasterize with lightning speed ----
  r <- raster::raster(raster::extent(voronoi_tess), res = resolution)
  r <- fasterize::fasterize(voronoi_tess, r, field = "value", fun = "sum")

  # specify resolution ----
  raster::extent(r) <- c(0,
                         ncol(r) * resolution,
                         0,
                         nrow(r) * resolution)

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    r <- util_rescale(r)
  }

  return(r)

}

