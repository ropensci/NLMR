#' metric_fractaldim
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
#' @aliases metric_fractaldim
#' @rdname metric_fractaldim
#'
#' @export
#'

nlm_patchmetrics <- function(nlm, poi){
 if(length(poi) == 2){
   nlm_ccl <- SDMTools::ConnCompLabel(nlm >= poi[1] & nlm <= poi[2])
 } else {
   nlm_ccl <- SDMTools::ConnCompLabel(nlm == poi)
 }
 nlm_patch_metrics <- dplyr::tbl_df(SDMTools::PatchStat(mat = nlm_ccl))
 return(nlm_patch_metrics)
}
