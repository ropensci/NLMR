#' metric_area
#'
#' @description Classify a matrix with values ranging 0-1 into proportions based upon a vector of class weightings.
#'
#' @details  The length of the weighting vector determines the number of classes in the resulting matrix.
#'
#' @param nlm [\code{matrix(x,y)}]\cr 2D matrix of data values.
#' @param poi [\code{numerical}]\cr  Vector of numeric values.
#'
#' @return Rectangular matrix reclassified values.
#'
#' @aliases metric_area
#' @rdname metric_area
#'
#' @export
#'

metric_area <- function(nlm, poi){


  cs <- dplyr::tbl_df(SDMTools::PatchStat(mat = nlm))
  return(cs)
}
