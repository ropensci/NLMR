#' nlm_randomcluster
#'
#' Simulates a random cluster nearest-neighbour neutral landscape.
#'
#' @param nCol [\code{integer(1)}]\cr
#' Number of columns in the raster.
#' @param nRow  [\code{integer(1)}]\cr
#' Number of rows in the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param neighbourhood [\code{numerical(1)}]\cr
#' Clusters are defined using a set of neighbourhood structures,
#'  4 (Rook's or von Neumann neighbourhood) (default), 8 (Queen's or Moore neighbourhood).
#' @param p [\code{numerical(1)}]\cr
#' The p value defines the proportion of   elements randomly selected to form
#' clusters.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return Raster with random values ranging from 0-1.
#'
#' @details
#' The implemented algorithm has been adopted from Etherington et al. 2014 and is itself an  adaptation of the MRC algorithm by Saura & Martínez-Millán (2000). The algorithm simulates a percolation map, which defines random clusters by running a connected labelling algorithm which detects clusters and gives each a unique ID. The algorithm controls the size and directional bias of the cluster with the proportion of the matrix that is within a cluster and with specifying a specific neighbourhood rule. Each cluster is than given a random value and non-cluster cells are assigned values by performing a nearest neighbour interpolation.
#'
#' @examples
#' nlm_randomcluster(nCol = 10, nRow = 10, resolution = 10, neighbourhood = 4, p = 0.4)
#'
#' @references
#' Saura, S. & Martínez-Millán, J. (2000) Landscape patterns simulation with a
#' modified random clusters method. \emph{Landscape Ecology}, 15, 661 – 678.
#'
#' Etherington TR, Holland EP, O’Sullivan D. 2015. NLMpy: A python software
#' package for the creation of neutral landscape models within a general
#' numerical framework. \emph{Methods in Ecology and Evolution} 6:164 – 168.
#'
#' @importFrom igraph components
#'
#' @aliases nlm_randomcluster
#' @rdname nlm_randomcluster
#'
#' @export
#'


nlm_randomcluster <-
  function(nCol,
           nRow,
           resolution = 1,
           neighbourhood = 4,
           p,
           rescale = TRUE) {

    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_numeric(resolution)
    checkmate::assert_numeric(p)
    checkmate::assert_true(p <= 1)
    checkmate::assert_true(neighbourhood == 4 || neighbourhood == 8)
    checkmate::assert_logical(rescale)

    # Create percolation array
    random_matrix <- raster::as.matrix(nlm_percolation(nCol, nRow, p, resolution = resolution))

    # Cluster identification (clustering of adjoining pixels) ----
    suppressMessages(clusters <-
      raster::clump(
        raster::raster(random_matrix),
        direction = neighbourhood
      ))

    # Number of individual clusters ----
    n_clusters <- max(raster::values(clusters), na.rm = TRUE)

    # Create random set of values for each the clusters ----
    types <- factor(stats::runif(n_clusters, 0, 1))
    num_types <- as.numeric(types)
    num_types <- R.utils::insert(num_types, 1, 0)

    # Apply values by indexing by cluster ----
    clustertype <- sample(num_types, n_clusters, replace = TRUE)
    raster::values(clusters) <-
      clustertype[raster::values(clusters)]

    # Convert array cells with values to Points, NA = empty space ----
    randomcluster_point <-
      raster::rasterToPoints(clusters, spatial = TRUE)

    # Create a tessellated surface ---
    randomcluster_tess <- dismo::voronoi(randomcluster_point)

    # Fill tessellated surface with values from points ----
    randomcluster_values <-
      sp::over(randomcluster_tess, randomcluster_point, fn = mean)
    randomcluster_spdf <-
      sp::SpatialPolygonsDataFrame(randomcluster_tess, randomcluster_values)

    # Convert to raster ----
    randomcluster_raster <- raster::rasterize(
      randomcluster_spdf,
      raster::raster(
        ncol = nCol,
        nrow = nRow,
        ext = raster::extent(randomcluster_spdf),
        resolution = c(1 / nCol, 1 / nRow)
      ),
      field = randomcluster_spdf@data[, 1],
      fun = "mean",
      update = TRUE,
      updateValue = "all",
      na.rm = TRUE
    )

    randomcluster_raster <- raster::crop(
      randomcluster_raster,
      raster::extent(0, 1, 0, 1)
    )


    # specify resolution ----
    raster::extent(randomcluster_raster) <- c(
      0,
      ncol(randomcluster_raster) * resolution,
      0,
      nrow(randomcluster_raster) * resolution
    )


    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomcluster_raster <- util_rescale(randomcluster_raster)
    }

    return(randomcluster_raster)
  }
