#' Method randomElementNLM
#' @name randomElementNLM-method
#' @rdname randomElementNLM-method
#' @exportMethod randomElementNLM

setGeneric("randomElementNLM", function(nCol, nRow, n, rescale = TRUE) {
  standardGeneric("randomElementNLM")
})


#' randomElementNLM
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical)
#' @param nRow Number of rows for the raster (numerical)
#' @param n The number of elements randomly selected to form the basis of nearest-neighbour clusters (numerical)
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' \dontrun{
#' randomElementNLM(nCol = 100, nRow = 100, n = 400)
#' }
#'
#' @aliases randomElementNLM
#' @rdname randomElementNLM-method
#'
#' @export
#'

setMethod(
  "randomElementNLM",
  definition = function(nCol, nRow, n, rescale = TRUE) {
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

    if (missing(n) || n > 0 || n < (nCol * nRow)) {
      ArgumentCheck::addWarning(
        msg = "'n' must be >= 1 and smaller than the sum of nCol and nRow. Value has been set to (nCol * nRow)/2",
        argcheck = Check
      )
      n <- ceiling((nCol * nRow)/2)
    }

    if (!is.logical(rescale)){
      ArgumentCheck::addWarning(
        msg = "'rescale' must be logical. Value has be set to TRUE",
        argcheck = Check
      )
      rescale <- TRUE
    }
    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # Create an empty array of correct dimensions
    array <- matrix(NA, nRow, nCol)

    # Insert value for n elements
    for (element in seq(1, n)){

      randomCol <- sample(c(1:nCol),1)
      randomRow <- sample(c(1:nRow),1)

      if(is.na(array[randomRow, randomCol])){
        array[randomRow, randomCol]  <- stats::runif(1,0,1)
      }

    }

    # Convert array cells with values to Points, NA = empty space
    randomElement_Point <- raster::rasterToPoints(raster::raster(array),spatial=TRUE)

    # Create a tessellated surface
    suppressMessages(
    randomElement_Tess <- methods::as(spatstat::dirichlet(spatstat::as.ppp(randomElement_Point)), "SpatialPolygons")
    )

    # Fill tessellated surface with values from points
    randomElement_Values <- sp::over(randomElement_Tess, randomElement_Point, fn = mean)
    randomElement_spdf   <- sp::SpatialPolygonsDataFrame(randomElement_Tess, randomElement_Values)

    randomElement_Raster <- raster::rasterize(randomElement_spdf,
                                              raster::raster(matrix(NA, nRow, nCol)),
                                              field = randomElement_spdf@data[,1])

    # Rescale values to 0-1
    if (rescale == TRUE) {
      randomElement_Raster <- rescaleNLM(randomElement_Raster)
    }

    return(randomElement_Raster)

  }
)

