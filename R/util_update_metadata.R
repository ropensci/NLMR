#' util_update_metadata
#'
#' Internal helper to standardize landscape metadata.
#'
#' @param x SpatRaster
#'
#' @return SpatRaster
#'
#' @keywords internal
#'
util_update_metadata <- function(x) {
  if (!inherits(x, "SpatRaster")) {
    stop("x must be a SpatRaster.")
  }

  names(x) <- rep("layer", terra::nlyr(x))
  terra::crs(x) <- ""

  x
}
