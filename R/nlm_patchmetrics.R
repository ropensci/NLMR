#
# nlm_patchmetrics <- function(nlm, poi){
#
#
#   if(length(poi) == 2){
#
#     nlm_ccl <- SDMTools::ConnCompLabel(nlm >= poi[1] & nlm <= poi[2])
#
#   } else {
#
#     nlm_ccl <- SDMTools::ConnCompLabel(randomClustery == poi)
#
#   }
#
#
#   nlm_patch_metrics <- dplyr::tbl_df(SDMTools::PatchStat(mat = nlm_ccl))
#
#   return(nlm_patch_metrics)
#
# }
#
# # nlm_patchmetrics(randomClustery, c(0.3, 0.5))
