#' nlm_gaussianfield
#'
#' Simulate spatially correlated random fields (Gaussian random fields) model.
#'
#' @param nCol [\code{numerical(1)}]\cr
#'  Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#'  Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param autocorr_range [\code{numerical(1)}]\cr
#'  Maximal distance of spatial autocorrelation
#' @param mag_var [\code{numerical(1)}]\cr
#'  Magnitude of variation in the field
#' @param beta [\code{numerical(1)}]\cr
#'  Mean value over the field.
#' @param nug [\code{numerical(1)}]\cr
#'  Small-scale variations in the field.
#' @param direction [\code{character("random" | "linear")}]\cr
#'  Direction of the gradient. Either random, or with a linear trend (default).
#' @param angle [\code{numerical(1)}]\cr
#'  Maximal distance of spatial autocorrelation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @examples
#' nlm_gaussianfield(nCol = 100, nRow = 100, 5)
#'
#' @aliases nlm_gaussianfield
#' @rdname nlm_gaussianfield
#'
#' @export
#'

nlm_gaussianfield <- function(nCol,
                              nRow,
                              resolution = 1,
                              autocorr_range = 10,
                              mag_var = 0.025,
                              beta = c(1, 0.01, 0.005),
                              nug = 1,
                              direction = "random",
                              angle = 1,
                              rescale = TRUE) {


  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_count(autocorr_range, positive = TRUE)
  checkmate::assert_numeric(mag_var)
  checkmate::assert_numeric(beta)
  checkmate::assert_numeric(nug)
  checkmate::assert_character(direction)
  checkmate::assert_count(angle, positive = TRUE)
  checkmate::assert_logical(rescale)

  # create data structure for spatial model
  xy <- expand.grid(1:nCol, 1:nRow)
  # Set the name of the spatial coordinates within the field
  names(xy) <- c("x", "y")

  # define the spatial model
  if (direction == "random") {
    spatial_sim <- gstat::gstat(
      formula = z~1,
      locations = ~x + y,
      dummy = TRUE,
      beta = beta,
      model = gstat::vgm(
        psill = mag_var,
        nugget = nug,
        model = "Exp",
        range = autocorr_range
      ),
      nmax = 20
    )
  }

  if (direction == "linear") {
    spatial_sim <- gstat::gstat(
      formula = z~1 + x + y,
      locations = ~x + y,
      dummy = TRUE,
      beta = beta,
      model = gstat::vgm(
        psill = mag_var,
        range = autocorr_range,
        model = "Exp"
      ),
      nmax = 20
    )
  }

  # make four simulations based on the stat object
  spatial_pred <- stats::predict(spatial_sim, newdata = xy, nsim = 1, messages = FALSE)

  # convert prediction to raster
  sp::gridded(spatial_pred) <- ~x + y
  pred_raster <- raster::raster(spatial_pred)
  raster::extent(pred_raster) <- c(0, 1, 0, 1)

  if (direction == "linear" & angle == 2) {
    pred_raster <- raster::flip(pred_raster, 2)
  }


  if (direction == "linear" & angle == 3) {
    pred_raster <- raster::t(pred_raster)
  }

  if (direction == "linear" & angle == 4) {
    pred_raster <- raster::flip(pred_raster, 1)
  }

  # specify resolution ----
  raster::extent(pred_raster) <- c(
    0,
    ncol(pred_raster) * resolution,
    0,
    nrow(pred_raster) * resolution
  )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    pred_raster <- util_rescale(pred_raster)
  }

  return(pred_raster)
}

# d ran- dom fields constrained by a particular semivariogram (Cressie 1993)
