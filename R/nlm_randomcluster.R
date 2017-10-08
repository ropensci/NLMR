# Function to create voronoi pylygons, kindly borrowed from https://stackoverflow.com/a/9405831
.voronoipolygons <- function(x) {
  crds <- x@coords

  z <- deldir::deldir(crds[, 1], crds[, 2])
  w <- deldir::tile.list(z)
  polys <- vector(mode = "list", length = length(w))
  for (i in seq(along = polys)) {
    pcrds <- cbind(w[[i]]$x, w[[i]]$y)
    pcrds <- rbind(pcrds, pcrds[1, ])
    polys[[i]] <-
      sp::Polygons(list(sp::Polygon(pcrds)), ID = as.character(i))
  }
  SP <-  sp::SpatialPolygons(polys)
  voronoi <- sp::SpatialPolygonsDataFrame(SP,
                                          data = data.frame(
                                            x = crds[, 1],
                                            y = crds[, 2],
                                            row.names = lapply(
                                              methods::slot(SP, "polygons"),
                                              function(x)methods::slot(x, "ID"))
                                          ))
}


#' nlm_randomcluster
#'
#' Create a random cluster nearest-neighbour neutral landscape model with values
#' ranging 0-1.
#'
#' @param nCol [\code{integer(1)}]\cr Number of columns in the raster.
#' @param nRow  [\code{integer(1)}]\cr Number of rows in the raster.
#' @param neighbourhood [\code{numerical(1)}]\cr Clusters are defined using a
#'                      set of neighbourhood structures, 4 (Rook's case),
#'                      8 (Queen's case).
#' @param p [\code{numerical(1)}]\cr The p value controls the proportion of
#'          elements randomly selected to form clusters.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' nlm_randomcluster(nCol = 10, nRow = 10, neighbourhood = 8, p = 0.4)
#'
#' @aliases nlm_randomcluster
#' @rdname nlm_randomcluster
#'
#' @export
#'

nlm_randomcluster  <-
  function(nCol, nRow, neighbourhood, p, rescale = TRUE) {
    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_numeric(p)
    checkmate::assert_true(p <= 1)
    checkmate::assert_true(neighbourhood == 4 || neighbourhood == 8)
    checkmate::assert_logical(rescale)

    # Create a random raster
    random_raster <- nlm_random(nCol, nRow)

    # Create percolation array
    random_raster <- util_classify(matrix(random_raster[], nCol, nRow),
                                         c(1 - p, p))

    # Cluster identification (clustering of adjoining pixels) ----
    suppressMessages(clusters <-
      raster::clump(raster::raster(random_raster),
                    direction = neighbourhood))

    # Number of individual clusters ----
    n_clusters <- max(raster::values(clusters), na.rm = TRUE)

    # Create random set of values for each the clusters ----
    types <- factor(stats::runif(n_clusters, 0, 1))
    num_types <- as.numeric(types)
    num_types <-  R.utils::insert(num_types, 1, 0)

    # Apply values by indexing by cluster ----
    clustertype <- sample(num_types, n_clusters, replace = TRUE)
    raster::values(clusters) <-
      clustertype[raster::values(clusters)]

    # Convert array cells with values to Points, NA = empty space ----
    randomcluster_point <-
      raster::rasterToPoints(clusters, spatial = TRUE)

    # Create a tessellated surface ---
    randomcluster_tess <- .voronoipolygons(randomcluster_point)

    # Fill tessellated surface with values from points ----
    randomcluster_values <-
      sp::over(randomcluster_tess, randomcluster_point, fn = mean)
    randomcluster_spdf   <-
      sp::SpatialPolygonsDataFrame(randomcluster_tess, randomcluster_values)

    # Convert to raster ----
    randomcluster_raster <- raster::rasterize(
      randomcluster_spdf,
      raster::raster(ncol=nCol, nrow=nRow, ext = raster::extent(randomcluster_spdf), resolution = c(1/nCol, 1/nRow)),
      field = randomcluster_spdf@data[, 1],
      fun = "mean",
      update = TRUE,
      updateValue = "all",
      na.rm = TRUE
    )

    randomcluster_raster <- raster::crop(randomcluster_raster, raster::extent(0,1,0,1))

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomcluster_raster <- util_rescale(randomcluster_raster)
    }

    return(randomcluster_raster)

  }


#####
## cut rasterized object to ectent of 0,1,0,1
#####
