#' Method randomRectangularClusterNLM
#' @name randomRectangularClusterNLM-method
#' @rdname randomRectangularClusterNLM-method
#' @exportMethod randomRectangularClusterNLM

setGeneric("randomRectangularClusterNLM", function(nCol, nRow, minL, maxL, rescale = TRUE) {
  standardGeneric("randomRectangularClusterNLM")
})


#' randomRectangularClusterNLM
#'
#' Create a random rectangular cluster neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical)
#' @param nRow Number of rows for the raster (numerical)
#' @param minL The minimum possible length of width and height for each random rectangular cluster.
#' @param maxL The maximum possible length of width and height for each random rectangular cluster.
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' \dontrun{
#' randomNLM(nCol = 100, nRow = 100)
#' }
#'
#' @aliases randomRectangularClusterNLM
#' @rdname randomRectangularClusterNLM-method
#'
#' @export
#'

setMethod(
  "randomRectangularClusterNLM",
  definition = function(nCol, nRow, minL, maxL, rescale = TRUE) {

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

    if (minL < 1 || minL > nCol || minL > nRow || minL >= maxL)
      ArgumentCheck::addError(
        msg = "'minL' must be >= 1 and < nCol, nRow and maxL",
        argcheck = Check
      )

    if (maxL < 1 || maxL > nCol || minL > nRow || maxL <= minL)
      ArgumentCheck::addError(
        msg = "'maxL' must be >= 1 and minL and < nCol, nRow ",
        argcheck = Check
      )

    if (!is.logical(rescale)) {
      ArgumentCheck::addWarning(msg = "'rescale' must be logical. Value has be set to TRUE",
                                argcheck = Check)
      rescale <- TRUE
    }

    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # Create an empty matrix of correct dimensions
    empty_array  <-  matrix(NA, nCol, nRow)

    # Keep applying random clusters until all elements have a value
    while (any(is.na(empty_array))){

      width <- sample(c(minL:maxL),1)
      height <- sample(c(minL:maxL),1)

      row <- sample(c(1:nRow),1)
      col <- sample(c(1:nCol),1)

      empty_array[if ((row + width) < nRow) row:(row + width) else row:nRow,
                  if ((col + height) < nCol) col:(col + height) else col:nCol] <- stats::runif(1, 0, 1)

    }

    # Transform to raster
    randomRectangularCluster_raster <- raster::raster(empty_array)

    # Rescale values to 0-1
    if (rescale == TRUE) {
      randomRectangularCluster_raster <- rescaleNLM(randomRectangularCluster_raster)
    }

    return(randomRectangularCluster_raster)

  }
)
