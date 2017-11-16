# nlm_polylands <- function(nCol,
#                           nRow,
#                           option = 1,
#                           germs,
#                           g,
#                           R,
#                           patch_classes){
#
#   # Tessellation method ----
#   if(option == 1){
#
#     # generate the germs from which the polygons are build ----
#     X <- runifpoint(germs)
#
#     # compute the Dirichlet tessellation ----
#     tess_surface <- dirichlet(X)
#
#     # whole bunch of conversions to get a raster in the end ----
#     tess_im <- as.im(tess_surface)
#     tess_data <- as.data.frame(tess_im)
#     coordinates(tess_data) <- ~ x + y
#     gridded(tess_data) <- TRUE
#     polylands_raster <- raster(tess_data)
#     polylands_raster <- raster::crop(polylands_raster,
#                                      raster::extent(0,1,0,1))
#
#     # specify resolution ----
#     raster::extent(polylands_raster) <- c(0,
#                                           ncol(polylands_raster)*resolution,
#                                           0,
#                                           nrow(polylands_raster)*resolution)
#
#   # Gibbs algorithm method  ----
#   if(option == 2){
#
#     # create point pattern (germs); step 2 in section 2.2 of Gauchel 2008
#     ## INFO: the Strauss process starts with a given Number of points and
#     ##       uses a minimization approach to fit a point pattern with a
#     ##       given interaction parameter (0 - hardcore proces;, 1 - poission
#     ##       process) and interaction radius (distance of points/germs being
#     ##       apart).
#     X <- rStrauss(200, gamma = g, R= R)
#
#     # ... and randomly allocate attribute class (here point pattern mark)
#
#
#
#     m <- sample(1:patch_classes, X$n, replace=TRUE)
#     marks(X) <- m
#
#
#     # Coerce to SpatialPointsDataFrame to preserve marks for interpolation ----
#     strauss_points <- maptools::as.SpatialPointsDataFrame.ppp(X)
#
#     # Create a tessellated surface ----
#     strauss_tess <- dismo::voronoi(strauss_points)
#
#     # Fill tessellated surface with values from points ----
#     strauss_values <-
#       sp::over(strauss_tess, strauss_points, fn = mean)
#
#     # Coerce to raster  ----
#     strauss_spdf   <-
#       sp::SpatialPolygonsDataFrame(strauss_tess, strauss_values)
#
#     polylands_raster <-
#       raster::rasterize(strauss_spdf,
#                         raster::raster(nrow = nRow,
#                                        ncol = nCol,
#                                        resolution = c(1/nCol, 1/nRow),
#                                        ext = raster::extent(strauss_spdf)),
#                         field = strauss_spdf@data[, 1])
#
#
#
#     polylands_raster <- raster::crop(polylands_raster,
#                                          raster::extent(0,1,0,1))
#
#     # specify resolution ----
#     raster::extent(polylands_raster) <- c(0,
#                                               ncol(polylands_raster)*resolution,
#                                               0,
#                                               nrow(polylands_raster)*resolution)
#
#   }
#
#   return(polylands_raster)
# }
