#' nlm_mosaictess
#'
#' @description Simulate a neutral landscape model using the tesselation approach introduced in Gaucherel (2008).
#'
#' @details
#' \code{nlm_mosaictess} offers the first option of simulating a neutral landscape model
#' described in Gaucherel (2008). It generates a random point pattern (germs)
#' with an independent distribution and uses the Voronoi tessellation to simulate mosaic landscapes.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param germs [\code{numerical(1)}]\cr
#' Intensity parameter (non-negative integer).
#' @param user_seed [\code{numerical(1)}]\cr
#' Set random seed for the simulation.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return SpatRaster
#'
#' @examples
#' # simulate polygonal landscapes
#' mosaictess <- nlm_mosaictess(ncol = 30, nrow = 60, germs = 200)
#'
#' \dontrun{
#' # visualize the NLM
#' terra::plot(mosaictess)
#' }
#'
#' @references
#' Gaucherel, C. (2008) Neutral models for polygonal landscapes with linear
#' networks. \emph{Ecological Modelling}, 219, 39 - 48.
#'
#' @aliases nlm_polylands
#' @rdname nlm_mosaictess
#'
#' @export
nlm_mosaictess <- function(ncol,
                           nrow,
                           resolution = 1,
                           germs,
                           user_seed = NULL,
                           rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(germs)
  checkmate::assert_integerish(user_seed, len = 1, lower = 1, null.ok = TRUE)

  if (!is.null(user_seed)) {
    set.seed(as.integer(user_seed))
  }

  # bounding box placing germs and clipping ----
  bounding_box <-  sf::st_sfc(sf::st_polygon(list(rbind(c(0, 0),
                                                        c(ncol, 0),
                                                        c(ncol, nrow),
                                                        c(0, nrow),
                                                        c(0, 0)))))

  # distribute the germs from which the polygons are build ----
  rnd_points <- sf::st_union(sf::st_sample(bounding_box, germs))

  # compute the voronoi tessellation ----
  voronoi_tess <- sf::st_voronoi(rnd_points)

  # clip and give random values ----
  voronoi_tess <- sf::st_intersection(sf::st_cast(voronoi_tess), bounding_box)
  voronoi_tess <- sf::st_sf(value = stats::runif(germs),
                            geometry = sf::st_sfc(voronoi_tess))

  # rasterize ----
  r <- terra::rast(
    ncol = ncol,
    nrow = nrow,
    xmin = 0,
    xmax = ncol,
    ymin = 0,
    ymax = nrow
  )
  r <- terra::rasterize(terra::vect(voronoi_tess), r, field = "value", fun = "sum")

  # specify resolution ----
  terra::ext(r) <- c(
    0,
    terra::ncol(r) * resolution,
    0,
    terra::nrow(r) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    r <- util_rescale(r)
  }

  return(r)
}

