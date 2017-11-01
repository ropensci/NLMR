# random_raster <- nlm_percolation(5, 5)
# random_raster <- raster(util_classify(matrix(random_raster[], 10, 10), c(1)))
# plot(random_raster)
#
# length()
#
# metric_lacunarity
#
# lacunarity_list <- list()
#
#
# # defince gliding box, which we be enlarged successively
# gliding_box_size <- 3
#
#
# gliding_box <- matrix(1, ncol = gliding_box_size, nrow = gliding_box_size)
#
# r2 <- focal(random_raster, gliding_box, fun=function(x) sum(x[x==1]))
# plot(r2)
#
# lacunarity_list[[i]] <- r2[]
# names(lacunarity_list)[i] <- gliding_box_size
#
# test_var  <- lapply(X = lacunarity_list, FUN =  var)
# test_mean  <- lapply(X = lacunarity_list, FUN =  mean)
#
#
#
# lacunarity_index <- function(x){
#
#   table(r2[])
#
# }
