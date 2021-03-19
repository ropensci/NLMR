#' nlm_mosaicfield
#'
#' @description Simulates a mosaic random field neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param n [\code{numerical(1)}]\cr
#' Number of steps over which the mosaic random field algorithm is run
#' @param mosaic_mean [\code{numerical(1)}]\cr
#' Mean value of the mosaic displacement distribution
#' @param mosaic_sd [\code{numerical(1)}]\cr
#' Standard deviation of the mosaic displacement distribution
#' @param collect [\code{logical(1)}]\cr
#' return \code{RasterBrick} of all steps 1:\code{n}
#' @param infinit [\code{logical(1)}]\cr
#' return raster of the random mosaic field algorithm with infinite steps
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer or List with RasterLayer/s and/or RasterBrick
#'
#' @references
#' Schwab, Dimitri, Martin Schlather, and Jürgen Potthoff. "A general class of
#' mosaic random fields." arXiv preprint arXiv:1709.01441 (2017). \cr
#' Baddeley, Adrian, Ege Rubak, and Rolf Turner. Spatial point patterns:
#' methodology and applications with R. CRC Press, 2015.
#'
#' @examples
#'
#' # simulate mosaic random field
#' mosaic_field <- nlm_mosaicfield(ncol = 100,
#'                                 nrow = 200,
#'                                 n = NA,
#'                                 infinit = TRUE,
#'                                 collect = FALSE)
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(mosaic_field)
#' }
#'
#' @aliases nlm_mosaicfield
#' @rdname nlm_mosaicfield
#'
#' @export


nlm_mosaicfield <- function(ncol,
                            nrow,
                            resolution  = 1,
                            n           = 20,
                            mosaic_mean = 0.5,
                            mosaic_sd   = 0.5,
                            collect     = FALSE,
                            infinit     = FALSE,
                            rescale     = TRUE) {
  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_count(n, positive = TRUE, na.ok = TRUE)
  checkmate::assert_numeric(mosaic_mean)
  checkmate::assert_numeric(mosaic_sd)
  checkmate::assert_logical(collect)
  checkmate::assert_logical(infinit)
  checkmate::assert_logical(rescale)

  mosaicfields_return <- list()

  if (!is.na(n)) {
    mosaicfield_result <- spatstat.core::rMosaicField(
      spatstat.core::rpoislinetess(4),
      stats::rnorm,
      dimyx = c(nrow, ncol),
      rgenargs = list(mean = mosaic_mean,
                      sd = mosaic_sd)
    )

    if (isTRUE(collect)) {
      mosaicfield_list <- list()
      mosaicfield_list[[1]] <- mosaicfield_result
    }

    for (i in 2:n) {
      mosaicfield_n <- spatstat.core::rMosaicField(
        spatstat.core::rpoislinetess(4),
        stats::rnorm,
        dimyx = c(nrow, ncol),
        rgenargs = list(mean = mosaic_mean,
                        sd = mosaic_sd)
      )

      mosaicfield_result <- mosaicfield_result + mosaicfield_n

      ### COLLECT STEPS IN LIST
      if (isTRUE(collect)) {
        mosaicfield_list[[i]] <- mosaicfield_n
        i <- i + 1
      }
    }

    # coerce spatstat image to raster and set proper resolution ----
    mosaicfield_raster <- raster::rasterFromXYZ(
      as.data.frame(mosaicfield_result))

    raster::extent(mosaicfield_raster) <- c(
      0,
      ncol(mosaicfield_raster) * resolution,
      0,
      nrow(mosaicfield_raster) * resolution
    )

    # Rescale values to 0-1
    if (rescale == TRUE) {
      mosaicfield_raster <- util_rescale(mosaicfield_raster)
    }

    mosaicfields_return$mosaicfield_raster <- mosaicfield_raster

    if (isTRUE(collect)) {
      names(mosaicfield_list) <- seq_along(mosaicfield_list)
      mosaicfield_list <-
        lapply(seq_along(mosaicfield_list), function(i) {
          mosaicfield_list[[i]] <- mosaicfield_list[[i]] / sqrt(i)
        })

      mosaicfield_list <-
        lapply(seq_along(mosaicfield_list), function(i) {
          # coerce spatstat image list to raster and set proper resolution ----
          mosaicfield_list[[i]] <- raster::rasterFromXYZ(
            as.data.frame(mosaicfield_list[[i]]))

          raster::extent(mosaicfield_list[[i]]) <- c(
            0,
            ncol(mosaicfield_list[[i]]) * resolution,
            0,
            nrow(mosaicfield_list[[i]]) * resolution
          )

          mosaicfield_list[[i]]
        })

      mosaicfields_brick <- raster::brick(mosaicfield_list)
      names(mosaicfields_brick) <-
        paste("Step: ", seq_along(mosaicfield_list))

      # Rescale values to 0-1
      if (rescale == TRUE) {
        mosaicfields_brick <- util_rescale(mosaicfields_brick)
      }


      mosaicfields_return$steps <- mosaicfields_brick
    }
  }

  if (isTRUE(infinit)) {
    # INFINITE STEPS:
    X <- spatstat.core::rLGCP(
      "exp",
      4,
      var = 1,
      dimyx = c(nrow, ncol),
      scale = .2,
      saveLambda = TRUE
    )
    mosaicfield_inf <- log(attr(X, "Lambda"))

    # coerce spatstat image to raster and set proper resolution ----
    mosaicfield_raster <-
      raster::rasterFromXYZ(as.data.frame(mosaicfield_inf))

    raster::extent(mosaicfield_raster) <- c(
      0,
      ncol(mosaicfield_raster) * resolution,
      0,
      nrow(mosaicfield_raster) * resolution
    )

    # Rescale values to 0-1
    if (rescale == TRUE) {
      mosaicfield_raster <- util_rescale(mosaicfield_raster)
    }


    mosaicfields_return$mosaicfield_inf <- mosaicfield_raster
  }


  if (length(mosaicfields_return) == 1) {
    mosaicfields_return <- mosaicfields_return[[1]]
  }

  return(mosaicfields_return)
}
