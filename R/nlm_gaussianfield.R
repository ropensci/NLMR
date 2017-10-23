#' nlm_gaussianfield
#'
#' Create an edge gradient neutral landscape model with values ranging 0-1.
#'
#' @param nCol [\code{numerical(1)}]\cr
#'  Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#'  Number of rows for the raster.
#' @param autocorr_range [\code{numerical(1)}]\cr
#' Maximal distance of spatial autocorrelation
#' @param direction [\code{character("random" | "linear")}]\cr
#' Direction of the gradient. Either random, or with a linear trend.
#' @param angle [\code{numerical(1)}]\cr
#' Maximal distance of spatial autocorrelation
#' @param rescale [\code{numeric(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer with xxxxxxx.
#'
#' @examples
#' nlm_gaussianfield(nCol = 100, nRow = 100, 5)
#'
#' @aliases nlm_gaussianfield
#' @rdname nlm_gaussianfield
#'
#' @export
#'


# Unconditional Gaussian simulation

# range:  range parameter in the variogram model it is possible to control the degree of spatial correlation
# Psill:  Magnitude of variation
# beta: mean NDVI over the field
# Nugget=3  // Small-scale variations
nlm_gaussianfield <- function(nCol,
                              nRow,
                              autocorr_range,
                              direction = "random",
                              angle = 1,
                              rescale = TRUE){

  # create data structure for spatial model
  xy <- expand.grid(1:nCol, 1:nRow)
  # Set the name of the spatial coordinates within the field
  names(xy) <- c("x","y")

  # define the spatial model
  if (direction == "random") {
    spatial_sim <- gstat::gstat(formula = z~1,
                                locations = ~x+y,
                                dummy = TRUE,
                                beta = 1,
                                model = gstat::vgm(psill=0.025,
                                                 model="Exp",
                                                 range=autocorr_range),
                                nmax = 20)
  }

  if (direction == "linear") {
    spatial_sim <- gstat::gstat(formula = z~1+x+y,
                                locations = ~x+y,
                                dummy = TRUE,
                                beta = c(1,0.01,0.005),
                                model = gstat::vgm(psill=0.025,
                                                 range=autocorr_range,
                                                 model='Exp'),
                                nmax = 20)

  }

  # make four simulations based on the stat object
  spatial_pred <- stats::predict(spatial_sim, newdata=xy, nsim=1, messages = FALSE)

  # convert prediction to raster
  sp::gridded(spatial_pred) <- ~x+y
  pred_raster <- raster::raster(spatial_pred)

  if (direction == "linear" & angle == 2) {
    pred_raster <- raster::flip(pred_raster, 2)
  }


  if (direction == "linear" & angle == 3) {
    pred_raster <- raster::t(pred_raster)
  }

  if (direction == "linear" & angle == 4) {
    pred_raster <- raster::flip(pred_raster, 1)
  }

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    pred_raster <- util_rescale(pred_raster)
  }

  return(pred_raster)

}


# random_rast <- nlm_gaussianfield(30, 30, 15, direction = "random")
# rasterVis::levelplot(random_rast)
#
# random_rast <- nlm_gaussianfield(100, 100, 5, direction = "linear", angle = 3)
# rasterVis::levelplot(random_rast)
#
#
#
# library(microbenchmark)
# benchm <- microbenchmark(
#
#   not_own = gaussian_field(r, 15, beta = c(1, 0, 0)) %>%  stretch(0, 1),
#   own = nlm_gaussianfields() %>% stretch(0, 1),
#   times = 9999
# )
#
# autoplot(benchm)


#
# library(gstat)
#
# ## Create a square field of side 100. The field can be seen as a grid of regularly spaced pixels
# Field = expand.grid(1:100, 1:100)
# ## Set the name of the spatial coordinates within the field
# names(Field)=c('x','y')
#
# ## Define the NDVI spatial structure inside the field
# ## Set the parameters of the semi-variogram
# Psill=15  // Magnitude of variation
# Range=30  // Maximal distance of autocorrelation
# Nugget=3  // Small-scale variations
# ## Set the semi-variogram model
# Beta=60   // mean NDVI over the field
# NDVI_modelling=gstat(formula=z~1, // We assume that there is a constant trend in the data (that could exist with regard to the coordinates for instance)
#                      locations=~x+y,
#                      dummy=T,    // Logical value to set to True for unconditional simulation
#                      beta=Beta,  // Necessity to set the average value over the field
#                      model=vgm(psill=Psill,
#                                range=Range ,
#                                nugget=Nugget,
#                                model='Sph'), // Spherical semi-variogram model
#                      nmax=40) // number of nearest observations used for each new prediction
#
# ## Simulate the NDVI spatial structure within the field
# NDVI_gaussian_field=predict(NDVI_modelling, newdata=Field, nsim=1) // nsim : number of simulations

