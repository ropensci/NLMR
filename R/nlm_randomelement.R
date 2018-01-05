#' nlm_randomelement
#'
#' @description Simulates a random rectangular cluster neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param n [\code{numerical(1)}]\cr
#' The number of elements randomly selected to form the basis of
#' nearest-neighbour clusters.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @details
#' The algorithm selects \code{n} random cell of the matrix and assigns them a
#' uniformly distributed random value. The cells are then converted to a point
#' pattern and interpolated by voronoi tessellation.
#'
#' @return Raster layer with values between 0 and 1
#'
#' @examples
#' # simulate random elements
#' random_element <- nlm_randomelement(ncol = 20, nrow = 20, n = 10)
#' \dontrun{
#' # visualize the NLM
#' util_plot(random_element)
#' }
#' @references
#' Etherington TR, Holland EP, O’Sullivan D. 2015. NLMpy: A python software
#' package for the creation of neutral landscape models within a general
#' numerical framework. \emph{Methods in Ecology and Evolution} 6:164 – 168.
#'
#' @aliases nlm_randomelement
#' @rdname nlm_randomelement
#'
#' @export
#'

nlm_randomelement <- function(ncol,
                              nrow,
                              resolution = 1,
                              n,
                              rescale = TRUE) {
  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_count(n, positive = TRUE)
  checkmate::assert_true(n < nrow * ncol)
  checkmate::assert_logical(rescale)

  # Create an empty matrix dimension ncol * nrow ---
  matrix <- matrix(NA, nrow, ncol)

  # Insert value for n elements ----
  for (element in seq(1, n)) {
    random_col <- sample(c(1:ncol), 1)
    random_row <- sample(c(1:nrow), 1)

    if (is.na(matrix[random_row, random_col])) {
      matrix[random_row, random_col] <- stats::runif(1, 0, 1)
    }
  }

  # Convert matrix cells with values to Points, NA = empty space ----
  randomelement_point <-
    raster::rasterToPoints(raster::raster(matrix), spatial = TRUE)

  # Create a tessellated surface
  randomelement_tess <- dismo::voronoi(randomelement_point)

  # Fill tessellated surface with values from points
  randomelement_values <-
    sp::over(randomelement_tess, randomelement_point, fn = mean)
  randomelement_spdf <-
    sp::SpatialPolygonsDataFrame(randomelement_tess, randomelement_values)

  randomelement_raster <-
    raster::rasterize(
      randomelement_spdf,
      raster::raster(
        nrow = nrow,
        ncol = ncol,
        resolution = c(1 / ncol, 1 / nrow),
        ext = raster::extent(randomelement_spdf)
      ),
      field = randomelement_spdf@data[, 1]
    )


  randomelement_raster <- raster::crop(
    randomelement_raster,
    raster::extent(0, 1, 0, 1)
  )

  # specify resolution ----
  raster::extent(randomelement_raster) <- c(
    0,
    ncol(randomelement_raster) * resolution,
    0,
    nrow(randomelement_raster) * resolution
  )


  # Rescale values to 0-1
  if (rescale == TRUE) {
    randomelement_raster <- util_rescale(randomelement_raster)
  }

  return(randomelement_raster)
}
