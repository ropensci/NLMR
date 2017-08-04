#' Method edgegradientNLM
#' @name edgegradientNLM-method
#' @rdname edgegradientNLM-method
#' @exportMethod edgegradientNLM

setGeneric("edgegradientNLM", function(nCol, nRow, direction = NA, rescale = TRUE) {
  standardGeneric("edgegradientNLM")
})


#' edgegradientNLM
#'
#' Create an edge gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical).
#' @param nRow Number of rows for the raster (numerical).
#' @param direction Direction of the gradient, if unspecified the direction is randomly determined (numeric (0-360), optional).
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#' @examples
#' \dontrun{
#' edgegradientNLM(x = 100, y = 100)
#' }
#'
#' @aliases edgegradientNLM
#' @rdname edgegradientNLM-method
#'
#' @export
#'

setMethod(
  "edgegradientNLM",
  definition = function(nCol, nRow, direction, rescale = TRUE) {

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

    if (missing(direction) || direction < 0 || direction > 360) {
      ArgumentCheck::addWarning(
        msg = "'direction' must be between 0 and 360. Value has be set to NA and will be choosen randomly",
        argcheck = Check
      )
      direction <- NA
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

    # If direction was not set, give it a random value between 0 and 360
    if (is.na(direction)) {
      direction <- stats::runif(1, 0, 360)
    }

    # Create planar gradient
    gradientRaster <-  planargradientNLM(50, 50, direction)

    # Transform to a central gradient
    edgeGradientRaster <-
      (abs(0.5 - gradientRaster) * -2) + 1

    # Rescale values to 0-
    if (rescale == TRUE) {
      edgeGradientRaster <- rescaleNLM(edgeGradientRaster)
    }

    return(edgeGradientRaster)

  }
)
