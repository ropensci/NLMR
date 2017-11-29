#' nlm_polylands
#'
#' @description Simulate the NLM introduced in Gaucherel (2008).
#'
#' @details
#' The function offers 2 of the 3 NLM described in Gaucherel (2008).
#' The first one (\code{option = 1}) is a tessellation method.
#' It generates a random point pattern (the germs) with an independent
#' distribution and uses the voronoi tessellation to simulate the patchy
#' landscapes.
#' The second one (\code{option = 2}) is the Gibbs algorithm method.
#' The method works in principal like the tessellation method, but instead of
#' a random point pattern one fits a simulated realization of the Strauss
#' process. The Strauss process starts with a given number of points and
#' uses a minimization approach to fit a point pattern with a given interaction
#' parameter (0 - hardcore process; 1 - poission process) and interaction radius
#' (distance of points/germs being apart).
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param option [\code{numerical(1)}]\cr
#' If \code{1} (default), the Tessellation method is used to simulate the NLM.
#' If \code{2}, the Gibbs algorithm method is used to simulate the NLM.
#' @param germs [\code{numerical(1)}]\cr
#' Intensity parameter (non-negative integer).
#' @param g [\code{numerical(1)}]\cr
#' Interaction parameter (a value between 0 and 1, inclusive - only used when \code{option = 2}).
#' @param R [\code{numerical(1)}]\cr
#' Interaction radius (non-negative integer).
#' @param patch_classes [\code{numerical(1)}]\cr
#' Number of classes for germs.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#' Otherwise, the distance in raster units is calculated.
#'
#' @return RasterLayer
#'
#' @examples
#' nlm_polylands(nCol = 50, nRow = 50, germs = 20)
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

nlm_polylands <- function(nCol,
                          nRow,
                          resolution = 1,
                          option = 1,
                          germs,
                          g,
                          R,
                          patch_classes,
                          rescale = TRUE){


  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_count(option, positive = TRUE)
  checkmate::assert_numeric(germs)
  if (!missing(g)) checkmate::assert_numeric(g)
  if (!missing(R)) checkmate::assert_numeric(R)
  if (!missing(patch_classes)) checkmate::assert_count(patch_classes, positive = TRUE)

  # Tessellation method ----
  if(option == 1){

    # generate the germs from which the polygons are build ----
    X <- spatstat::runifpoint(germs)

    # compute the Dirichlet tessellation ----
    tess_surface <- spatstat::dirichlet(X)

    # whole bunch of conversions to get a raster in the end ----
    tess_im <- spatstat::as.im(tess_surface, dimyx=c(nCol, nRow))
    tess_data <- raster::as.data.frame(tess_im)
    sp::coordinates(tess_data) <- ~ x + y
    sp::gridded(tess_data) <- TRUE
    polylands_raster <- raster::deratify(raster::raster(tess_data))
    polylands_raster <- raster::crop(polylands_raster,
                                     raster::extent(0,1,0,1))

    # specify resolution ----
    raster::extent(polylands_raster) <- c(0,
                                          ncol(polylands_raster)*resolution,
                                          0,
                                          nrow(polylands_raster)*resolution)

  }

  # Gibbs algorithm method  ----
  if(option == 2){

    # create point pattern (germs); step 2 in section 2.2 of Gauchel 2008
    ## INFO: the Strauss process starts with a given Number of points and
    ##       uses a minimization approach to fit a point pattern with a
    ##       given interaction parameter (0 - hardcore proces;, 1 - poission
    ##       process) and interaction radius (distance of points/germs being
    ##       apart).
    X <- spatstat::rStrauss(200, gamma = g, R= R)

    # ... and randomly allocate attribute class (here point pattern mark)
    m <- sample(1:patch_classes, X$n, replace=TRUE)
    spatstat::marks(X) <- m

    # Coerce to SpatialPointsDataFrame to preserve marks for interpolation ----
    strauss_points <- maptools::as.SpatialPointsDataFrame.ppp(X)

    # Create a tessellated surface ----
    strauss_tess <- dismo::voronoi(strauss_points)

    # Fill tessellated surface with values from points ----
    strauss_values <-
      sp::over(strauss_tess, strauss_points, fn = mean)

    # Coerce to raster  ----
    strauss_spdf   <-
      sp::SpatialPolygonsDataFrame(strauss_tess, strauss_values)

    polylands_raster <-
      raster::rasterize(strauss_spdf,
                        raster::raster(nrow = nRow,
                                       ncol = nCol,
                                       resolution = c(1/nCol, 1/nRow),
                                       ext = raster::extent(strauss_spdf)),
                        field = strauss_spdf@data[, 1])



    polylands_raster <- raster::crop(polylands_raster,
                                     raster::extent(0,1,0,1))

    # specify resolution ----
    raster::extent(polylands_raster) <- c(0,
                                          ncol(polylands_raster)*resolution,
                                          0,
                                          nrow(polylands_raster)*resolution)

  }

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    polylands_raster <- util_rescale(polylands_raster)
  }

  return(polylands_raster)
}

