# nlm_polylands <- function(germs,
#                           option = 1){
#
#   # Tessellation method
#   if(option == 1){
#
#     # generate the germs from which the polygons are built
#     X <- runifpoint(germs)
#
#     # compute the Dirichlet tessellation
#     tess_surface <- dirichlet(X)
#
#     # whole bunch of conversions to get a raster in the end
#     tess_im <- as.im(tess_surface)
#     tess_data <- as.data.frame(tess_im)
#     coordinates(tess_data) <- ~ x + y
#     gridded(tess_data) <- TRUE
#     polylands_raster <- raster(tess_data)
#
#   }
#
#
#   return(polylands_raster)
# }
