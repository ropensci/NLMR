#' Method distancegradientNLM
#' @name distancegradientNLM-method
#' @rdname distancegradientNLM-method
#' @exportMethod distancegradientNLM

setGeneric("distancegradientNLM", function(nCol, nRow, origin, rescale = TRUE) {
  standardGeneric("distancegradientNLM")
})


#' distancegradientNLM
#'
#' Create a distance gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns (numerical)
#' @param nRow Number of rows (numerical)
#' @param origin Edge coordinates of the origin of the distance measurement (Numeric vector of xmin, xmax, ymin, ymax)
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with distance measurements starting in a predefined origin.
#'
#'
#' @examples
#' \dontrun{
#' distancegradientNLM(x = 100, y = 100, origin = (20, 30, 10, 15))
#' }
#'
#' @aliases distancegradientNLM
#' @rdname distancegradientNLM-method
#'
#' @export
#'

setMethod(
  "distancegradientNLM",
  definition = function(nCol, nRow, origin, rescale = TRUE) {

    suppressWarnings("In couldBeLonLat(x) : CRS is NA. Assuming it is longitude/latitude")

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

    if (missing(origin) || any(origin < 0) || any(origin > nCol) || any(origin > nRow))
      ArgumentCheck::addError(
        msg = "'origin' must be between nCol and nRow.",
        argcheck = Check
      )

    if (!is.logical(rescale)){
      ArgumentCheck::addWarning(
        msg = "'rescale' must be logical. Value has be set to TRUE",
        argcheck = Check
      )
      rescale <- TRUE
    }

    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # create empty raster
    distancegradient <-
      raster::raster(raster::extent(0, nCol, 0, nRow))
    # set origin to 1
    distancegradient[raster::extent(origin)] <- 1

    # measure distance to origin
    suppressWarnings(
    distancegradient <- raster::distance(distancegradient)
    )

    if (rescale == TRUE) {
      distancegradient <- rescaleNLM(distancegradient)
    }

    return(distancegradient)


  }
)
