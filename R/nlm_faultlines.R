# nlm_faultline <- function(n          = 20,
#                           nCol       = 50,
#                           nRow       = 50,
#                           collect    = TRUE,
#                           resolution = 1,
#                           infinit    = TRUE,
#                           rescale    = TRUE){
#
#   faultlines_return <- list()
#
#   if (!is.na(n)) {
#
#     faultline_result <- rMosaicField(rpoislinetess(4),
#                                      rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
#
#     if (isTRUE(collect)) {
#       i <- 2
#       faultline_list <- list()
#       faultline_list[[1]] <- faultline_result
#     }
#
#     for (i in 1:n) {
#       faultline_n <- rMosaicField(rpoislinetess(4),
#                                   rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
#       faultline_result <- faultline_result + faultline_n
#
#       ### COLLECT STEPS IN LIST
#       if (isTRUE(collect)) {
#         faultline_list[[i]] <- faultline_n
#         i <- i + 1
#       }
#     }
#
#     # coerce spatstat image to raster and set proper resolution ----
#     faultline_df <- as.data.frame(faultline_result)
#     coordinates(faultline_df) <- ~ x + y
#     gridded(faultline_df) <- TRUE
#     faultline_raster <- raster(faultline_df)
#     raster::extent(faultline_raster) <- c(0,
#                                           ncol(faultline_raster)*resolution,
#                                           0,
#                                           nrow(faultline_raster)*resolution)
#
#     # Rescale values to 0-1
#     if (rescale == TRUE) {
#       faultline_raster <- util_rescale(faultline_raster)
#     }
#
#     faultlines_return$faultline_raster <- faultline_raster
#
#     if (isTRUE(collect)) {
#
#       names(faultline_list) <- 1:length(faultline_list)
#       faultline_list <- purrr::map(seq_along(faultline_list), function(i) {
#
#         faultline_list[[i]] <- faultline_list[[i]]/sqrt(i)
#
#       })
#
#       faultline_list <- purrr::map(seq_along(faultline_list), function(i) {
#
#         # coerce spatstat image list to raster and set proper resolution ----
#         faultline_list[[i]] <- as.data.frame(faultline_list[[i]])
#         coordinates(faultline_list[[i]]) <- ~ x + y
#         gridded(faultline_list[[i]]) <- TRUE
#         faultline_list[[i]] <- raster(faultline_list[[i]])
#         raster::extent(faultline_list[[i]]) <- c(0,
#                                                  ncol(faultline_list[[i]])*resolution,
#                                                  0,
#                                                  nrow(faultline_list[[i]])*resolution)
#
#         faultline_list[[i]]
#       })
#
#       faultlines_return$steps = faultline_list
#
#     }
#
#
#   }
#
#   if (isTRUE(infinit)) {
#
#     # INFINITE STEPS:
#     X <- rLGCP("exp", 4, var=1, scale=.2, saveLambda=TRUE)
#     faultline_inf <- log(attr(X, "Lambda"))
#     faultlines_return$faultline_inf <- faultline_inf
#   }
#
#
#   return(faultlines_return)
#
#
# }
#
#
# nlm_faultline()
#
# #
# #
# # X <- runifpoint(2)
# # plot(dirichlet(X))
# # faultline_result <- rMosaicField(dirichlet(X),
# #                                  rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
# #
# #
# #
# # for (i in 1:n) {
# #   faultline_n <- rMosaicField(dirichlet(runifpoint(2)),
# #                               rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
# #   faultline_result <- faultline_result + faultline_n
# #
# #   ### COLLECT STEPS IN LIST
# # }
