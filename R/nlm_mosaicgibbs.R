#' nlm_mosaicgibbs
#'
#' @description Simulate the NLM introduced in Gaucherel (2008).
#'
#' @details
#' \code{nlm_mosaicgibbs} offers the second option of simulating a neutral landscape model
#' described in Gaucherel (2008).
#' The method works in principal like the tessellation method (\code{nlm_mosaictess}),
#' but instead of a random point pattern one fits a simulated realization of the Strauss
#' process. The Strauss process starts with a given number of points and
#' uses a minimization approach to fit a point pattern with a given interaction
#' parameter (0 - hardcore process; 1 - poission process) and interaction radius
#' (distance of points/germs being apart).
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param germs [\code{numerical(1)}]\cr
#' Intensity parameter (non-negative integer).
#' @param g [\code{numerical(1)}]\cr
#' Interaction parameter (a value between 0 - hardcore process and 1- poission process).
#' @param R [\code{numerical(1)}]\cr
#' Interaction radius (non-negative integer) for the fitting of the spatial point
#' pattern process.
#' @param patch_classes [\code{numerical(1)}]\cr
#' Number of classes for germs.
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate polygonal landscapes
#' mosaicgibbs <- nlm_mosaicgibbs(ncol = 40,
#'                               nrow = 30,
#'                               germs = 20,
#'                               g = 0.5,
#'                               R = 0.02,
#'                               patch_classes = 12)
#'
#' \dontrun{
#' # visualize the NLM
#' util_plot(mosaicgibbs)
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
                            g,
                            R,
                            patch_classes) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(germs)
  checkmate::assert_numeric(g)
  checkmate::assert_numeric(R)
  checkmate::assert_count(patch_classes, positive = TRUE)

  # create point pattern (germs); step 2 in section 2.2 of Gauchel 2008
  x <- spatstat::rStrauss(200, gamma = g, R = R)

  # ... and randomly allocate attribute class (here point pattern mark)
  m <- sample(1:patch_classes, x$n, replace = TRUE)
  spatstat::marks(x) <- m

  # Coerce to SpatialPointsDataFrame to preserve marks for interpolation ----
  strauss_points <- data.frame(x)
  sp::coordinates(strauss_points) <- ~ x + y

  # Create a tessellated surface ----
  strauss_tess <- dismo::voronoi(strauss_points)

  # Fill tessellated surface with values from points ----
  strauss_values <-
    sp::over(strauss_tess, strauss_points, fn = mean)

  # Coerce to raster  ----
  strauss_spdf <-
    sp::SpatialPolygonsDataFrame(strauss_tess, strauss_values)

  polylands_raster <-
    raster::rasterize(
      strauss_spdf,
      raster::raster(
        nrow = nrow,
        ncol = ncol,
        resolution = c(1 / ncol, 1 / nrow),
        ext = raster::extent(strauss_spdf)
      ),
      field = strauss_spdf@data[, 1]
    )

  polylands_raster <- raster::crop(polylands_raster,
                                   raster::extent(0, 1, 0, 1))

  # specify resolution ----
  raster::extent(polylands_raster) <- c(0,
                                        ncol(polylands_raster) * resolution,
                                        0,
                                        nrow(polylands_raster) * resolution)

  return(polylands_raster)

}
