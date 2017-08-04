#' Method randomNLM
#' @name randomNLM-method
#' @rdname randomNLM-method
#' @exportMethod randomNLM

setGeneric("randomNLM", function(nCol, nRow, rescale = TRUE) {
  standardGeneric("randomNLM")
})


#' distancegradientNLM
#'
#' Create a spatially random neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical)
#' @param nRow Number of rows for the raster (numerical)
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
#' @aliases randomNLM
#' @rdname randomNLM-method
#'
#' @export
#'

setMethod(
  "randomNLM",
  definition = function(nCol, nRow, rescale = TRUE) {

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

    if (!is.logical(rescale)){
      ArgumentCheck::addWarning(
        msg = "'rescale' must be logical. Value has been set to TRUE",
        argcheck = Check
      )
      rescale <- TRUE
    }

    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    random_Raster <-
      raster::raster(matrix(stats::runif(nCol * nRow, 0, 1), nCol, nRow))

    # Rescale values to 0-1
    if (rescale == TRUE) {
      random_Raster <- rescaleNLM(random_Raster)
    }

    return(random_Raster)

  }
)
