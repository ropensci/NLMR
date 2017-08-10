# Function to create voronoi pylygons, kindly borrowed from https://stackoverflow.com/a/9405831
.voronoipolygons <- function(x) {

  crds <- x@coords

  z <- deldir::deldir(crds[,1], crds[,2])
  w <- deldir::tile.list(z)
  polys <- vector(mode='list', length=length(w))
  for (i in seq(along=polys)) {
    pcrds <- cbind(w[[i]]$x, w[[i]]$y)
    pcrds <- rbind(pcrds, pcrds[1,])
    polys[[i]] <- sp::Polygons(list(sp::Polygon(pcrds)), ID=as.character(i))
  }
  SP <-  sp::SpatialPolygons(polys)
  voronoi <- sp::SpatialPolygonsDataFrame(SP,
                                          data=data.frame(x=crds[,1],
                                                          y=crds[,2],
                                                          row.names=lapply(methods::slot(SP, 'polygons'),
                                                                           function(x) methods::slot(x, 'ID'))))
}


#' randomElementNLM
#'
#' Create a random rectangular cluster neutral landscape model with values
#' ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr Number of rows for the raster.
#' @param n [\code{numerical(1)}]\cr The number of elements randomly selected
#'          to form the basis of nearest-neighbour clusters.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default),
#'                the values are rescaled between 0-1.
#'
#' @return RasterLayer with random values ranging from 0-1.
#'
#' @examples
#' randomElementNLM(nCol = 10, nRow = 10, n = 40)
#'
#'
#' @aliases randomElementNLM
#' @rdname randomElementNLM
#'
#' @export
#'

randomElementNLM <- function(nCol, nRow, n, rescale = TRUE) {
  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_count(n, positive = TRUE)
  checkmate::assert_true(n < nRow * nCol)
  checkmate::assert_logical(rescale)

  # Create an empty matrix dimension nCol * nRow ---
  matrix <- matrix(NA, nRow, nCol)

  # Insert value for n elements ----
  for (element in seq(1, n)) {
    randomCol <- sample(c(1:nCol), 1)
    randomRow <- sample(c(1:nRow), 1)

    if (is.na(matrix[randomRow, randomCol])) {
      matrix[randomRow, randomCol]  <- stats::runif(1, 0, 1)
    }

  }

  # Convert matrix cells with values to Points, NA = empty space ----
  randomelement_point <-
    raster::rasterToPoints(raster::raster(matrix), spatial = TRUE)

  # Create a tessellated surface
  randomelement_tess <- .voronoipolygons(randomelement_point)

  # Fill tessellated surface with values from points
  randomelement_values <-
    sp::over(randomelement_tess, randomelement_point, fn = mean)
  randomelement_spdf   <-
    sp::SpatialPolygonsDataFrame(randomelement_tess, randomelement_values)

  randomelement_raster <- raster::rasterize(randomelement_spdf,
                                            raster::raster(matrix(NA,
                                                                  nRow,
                                                                  nCol)),
                                            field = randomelement_spdf@data[, 1])

  # Rescale values to 0-1
  if (rescale == TRUE) {
    randomelement_raster <- rescaleNLM(randomelement_raster)
  }

  return(randomelement_raster)

}
