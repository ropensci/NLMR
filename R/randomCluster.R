#' Method randomClusterNLM
#' @name randomClusterNLM-method
#' @rdname randomClusterNLM-method
#' @exportMethod randomClusterNLM

setGeneric("randomClusterNLM", function(nCol, nRow, n, p, rescale = TRUE) {
  standardGeneric("randomClusterNLM")
})


#' randomClusterNLM
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical)
#' @param nRow Number of rows for the raster (numerical)
#' @param n Clusters are defined using a set of neighbourhood structures, 4 = '4-neighbourhood', 8 = '8-neighbourhood'
#' @param p The p value controls the proportion of elements randomly selected to form clusters.
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' \dontrun{
#' randomClusterNLM(nCol = 100, nRow = 100)
#' }
#'
#' @aliases randomClusterNLM
#' @rdname randomClusterNLM-method
#'
#' @export
#'

setMethod(
  "randomClusterNLM",
  definition = function(nCol, nRow, n, p, rescale = TRUE) {
    require(maptools)
    # Check Function arguments
    Check <- ArgumentCheck::newArgCheck()

    if (nCol < 1)
      ArgumentCheck::addError(
        msg = "'nCol' must be >= 1",
        argcheck = Check
      )

    if (nRow < 1)
      ArgumentCheck::addError(
        msg = "'nRow' must be >= 1",
        argcheck = Check
      )

    if (missing(n) || n == 4 || n == 8) {
      ArgumentCheck::addWarning(
        msg = "'n' must be 4 or 8. Value has been set 4",
        argcheck = Check
      )
      n <- 4
    }

    if (missing(p) || p <= 1 || p >= 0) {
      ArgumentCheck::addWarning(
        msg = "'p' must be between 0 and 1. Value has been set 0.4",
        argcheck = Check
      )
      p <- 0.4
    }


    if (!is.logical(rescale)){
      ArgumentCheck::addWarning(
        msg = "'rescale' must be logical. Value has been set to TRUE",
        argcheck = Check
      )
      rescale <- TRUE
    }

    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # Create percolation array
    array <- randomNLM(nCol, nRow)

    # Create percolation array
    percolationArray = classifyArray(matrix(array[],nCol,nRow), c(1 - p, p))

    # Cluster identification (clustering of adjoining pixels)
    clusters <- raster::clump(raster::raster(percolationArray), direction = n)

    # Number of individual cluster
    nClusters <- max(raster::values(clusters), na.rm = TRUE)

    # Create random set of values for each the clusters
    types <- factor(stats::runif(nClusters, 0, 1))
    numTypes <- as.numeric(types)
    numTypes <-  R.utils::insert(numTypes, 1, 0)

    # Apply values by indexing by cluster
    clustertype <- sample(numTypes, nClusters, replace = TRUE)
    raster::values(clusters) <- clustertype[raster::values(clusters)]

    # Convert array cells with values to Points, NA = empty space
    randomCluster_Point <- raster::rasterToPoints(clusters,spatial=TRUE)

    # Create a tessellated surface
    suppressMessages(
    randomCluster_Tess <- methods::as(spatstat::dirichlet(spatstat::as.ppp(randomCluster_Point@coords,
                                                                           spatstat::ripras(randomCluster_Point@coords, shape = "rectangle"))),
                                      "SpatialPolygons")
    )

    # Fill tessellated surface with values from points
    randomCluster_Values <- sp::over(randomCluster_Tess, randomCluster_Point, fn = mean)
    randomCluster_spdf   <- sp::SpatialPolygonsDataFrame(randomCluster_Tess, randomCluster_Values)

    # Convert to raster
    randomCluster_Raster <- raster::rasterize(randomCluster_spdf,
                                              raster::raster(matrix(NA, nRow, nCol)),
                                              field = randomCluster_spdf@data[,1],
                                              fun = "mean",
                                              update = TRUE,
                                              updateValue = "all",
                                              na.rm = TRUE)
    # Rescale values to 0-1
    if (rescale == TRUE) {
      randomCluster_Raster <- rescaleNLM(randomCluster_Raster)
    }

    return(randomCluster_Raster)

  }
)


# plot(as.im.RasterLayer(raster::raster(percolationArray)))
# Z <-  spatstat::connected(as.im.RasterLayer(raster::raster(percolationArray)), background = 0, method="interpreted")
# plot(Z)
# test <- raster::raster(Z)
#
# test <- matrix(as.numeric(spatstat::as.matrix.im(Z)), 100, 100)
# test <- raster::raster(test)
# plot(test)


# test <- SDMTools::ConnCompLabel(percolationArray)
# image(t(test),col=c('grey',rainbow(length(unique(test))-1)))
