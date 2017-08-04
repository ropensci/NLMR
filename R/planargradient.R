#' Method planargradientNLM
#' @name planargradientNLM-method
#' @rdname planargradientNLM-method
#' @exportMethod planargradientNLM

setGeneric("planargradientNLM", function(nCol,
                                         nRow,
                                         direction = NA,
                                         rescale = FALSE) {
  standardGeneric("planargradientNLM")
})


#' planargradientNLM
#'
#'Create a planar gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical).
#' @param nRow Number of rows for the raster (numerical).
#' @param direction Direction of the gradient, if unspecified the direction is randomly determined (numeric (0-360), optional).
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' \dontrun{
#' planargradientNLM(nCol = 100, nRow = 100)
#' }
#'
#' @aliases planargradientNLM
#' @rdname planargradientNLM-method
#'
#' @export
#'


setMethod(
  "planargradientNLM",
  definition =  function(nCol,
                         nRow,
                         direction  = NA,
                         rescale = TRUE) {
    # Check Function arguments
    Check <- ArgumentCheck::newArgCheck()

    if (nCol < 1)
      ArgumentCheck::addError(msg = "'nCol' must be >= 1",
                              argcheck = Check)

    if (nRow < 1)
      ArgumentCheck::addError(msg = "'nRow' must be >= 1",
                              argcheck = Check)

    if (missing(direction) || direction < 0 || direction > 360) {
      ArgumentCheck::addWarning(
        msg = "'direction' must be between 0 and 360. Value has be set to NA and will be choosen randomly",
        argcheck = Check
      )
      direction <- NA
    }

    if (!is.logical(rescale)) {
      ArgumentCheck::addWarning(msg = "'rescale' must be logical. Value has be set to TRUE",
                              argcheck = Check)
      rescale <- TRUE
    }

    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # If direction was not set, give it a random value between 0 and 360
    if (is.na(direction)) {
      direction <- stats::runif(1, 0, 360)
    }

    # Determine the eastness and southness of the direction
    eastness   <- sin(pracma::deg2rad(direction))
    southness  <- cos(pracma::deg2rad(direction)) * -1

    # Create arrays of row and column index
    colIndex <- matrix(0:(nCol - 1), nCol, nRow)
    rowIndex <- matrix(0:(nRow - 1) , nCol, nRow, byrow = T)

    # Create gradient array
    gradientArray  <-
      (southness * rowIndex + eastness * colIndex)

    # Transform to raster
    gradientRaster <- raster::raster(gradientArray)

    # Rescale values to 0-1
    if (rescale == TRUE) {
      gradientRaster <- rescaleNLM(gradientRaster)
    }

    return(gradientRaster)

  }
)
