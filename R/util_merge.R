#' util_merge
#'
#' Merge a primary raster with other rasters weighted by scaling factors.
#'
#' @param primary_nlm [\code{Raster* object}]\cr  Primary \code{Raster* object}
#' @param secondary_nlm [\code{Raster* object} or \code{list}]\cr A list or stack of \code{Raster* object}s that are merged with the primary \code{Raster* object}
#' @param scalingfactor [\code{numerical(1)}]\cr Weight for the secondary \code{Raster* objects}
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return Rectangular matrix with values ranging from 0-1
#'
#' @examples
#' util_merge(nlm_percolation(50, 50), nlm_random(50, 50))
#'
#' @export
#'


util_merge <- function(primary_nlm,
                       secondary_nlm,
                       scalingfactor = 1,
                       rescale = TRUE) {

  # Check function arguments ----
  checkmate::assert_number(scalingfactor)
  checkmate::assert_logical(rescale)

  if (class(secondary_nlm) != "RasterStack") {
    secondary_nlm <- raster::stack(secondary_nlm)
  }

  if (length(secondary_nlm@layers) > 1) {
    nlm_merge <- primary_nlm + (sum(secondary_nlm) * scalingfactor)
  } else {
    nlm_merge <- primary_nlm + (secondary_nlm * scalingfactor)
  }

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    nlm_merge <- util_rescale(nlm_merge)
  }

  return(nlm_merge)
}
