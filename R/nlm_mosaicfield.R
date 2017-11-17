#' nlm_mosaicfield
#'
#' @description Create a mosaic random field neutral landscape model.
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param n [\code{numerical(1)}]\cr
#' Number of steps that the mosaic random field algorithm is run
#' @param mosaic_mean [\code{numerical(1)}]\cr
#' Mean value of the mosaic displacement distribution
#' @param mosaic_sd [\code{numerical(1)}]\cr
#' Standard deviation of the mosaic displacement distribution
#' @param collect [\code{logical(1)}]\cr
#' return RasterBrick of all steps 1:n
#' @param infinit [\code{logical(1)}]\cr
#' return raster of the random mosaic field algorithm with infinite steps
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @return RasterLayer or List with RasterLayer(s) and/or RasterBrick
#'
#' @references
#' Schwab, Dimitri, Martin Schlather, and Jürgen Potthoff. "A general class of
#' mosaic random fields." arXiv preprint arXiv:1709.01441 (2017). \cr
#' Baddeley, Adrian, Ege Rubak, and Rolf Turner. Spatial point patterns:
#' methodology and applications with R. CRC Press, 2015.
#'
#' @examples
#' nlm_mosaicfield(nCol = 100,
#'                 nRow = 100,
#'                 n = 5,
#'                 infinit = FALSE,
#'                 collect = FALSE)
#'
#' @aliases nlm_mosaicfield
#' @rdname nlm_mosaicfield
#'
#' @export


nlm_mosaicfield <- function(nCol        = 50,
                            nRow        = 50,
                            resolution  = 1,
                            n           = 20,
                            mosaic_mean = 0.5,
                            mosaic_sd   = 0.5,
                            collect     = FALSE,
                            infinit     = FALSE,
                            rescale     = TRUE){

  mosaicfields_return <- list()

  if (!is.na(n)) {

    mosaicfield_result <- spatstat::rMosaicField(spatstat::rpoislinetess(4),
                                                 stats::rnorm,
                                                 dimyx=c(nCol,nRow),
                                                 rgenargs=list(mean=mosaic_mean,
                                                               sd=mosaic_sd))

    if (isTRUE(collect)) {
      i <- 2
      mosaicfield_list <- list()
      mosaicfield_list[[1]] <- mosaicfield_result
    }

    for (i in 1:n) {
      mosaicfield_n <- spatstat::rMosaicField(spatstat::rpoislinetess(4),
                                              stats::rnorm,
                                              dimyx=c(nCol,nRow),
                                              rgenargs=list(mean=mosaic_mean,
                                                            sd=mosaic_sd))

      mosaicfield_result <- mosaicfield_result + mosaicfield_n

      ### COLLECT STEPS IN LIST
      if (isTRUE(collect)) {
        mosaicfield_list[[i]] <- mosaicfield_n
        i <- i + 1
      }
    }

    # coerce spatstat image to raster and set proper resolution ----
    mosaicfield_df <- as.data.frame(mosaicfield_result)
    sp::coordinates(mosaicfield_df) <- ~ x + y
    sp::gridded(mosaicfield_df) <- TRUE
    mosaicfield_raster <- raster::raster(mosaicfield_df)
    raster::extent(mosaicfield_raster) <- c(0,
                                            ncol(mosaicfield_raster)*resolution,
                                            0,
                                            nrow(mosaicfield_raster)*resolution)

    # Rescale values to 0-1
    if (rescale == TRUE) {
      mosaicfield_raster <- util_rescale(mosaicfield_raster)
    }

    mosaicfields_return$mosaicfield_raster <- mosaicfield_raster

    if (isTRUE(collect)) {

      names(mosaicfield_list) <- 1:length(mosaicfield_list)
      mosaicfield_list <- purrr::map(seq_along(mosaicfield_list), function(i) {

        mosaicfield_list[[i]] <- mosaicfield_list[[i]]/sqrt(i)

      })

      mosaicfield_list <- purrr::map(seq_along(mosaicfield_list), function(i) {

        # coerce spatstat image list to raster and set proper resolution ----
        mosaicfield_list[[i]] <- as.data.frame(mosaicfield_list[[i]])
        sp::coordinates(mosaicfield_list[[i]]) <- ~ x + y
        sp::gridded(mosaicfield_list[[i]]) <- TRUE
        mosaicfield_list[[i]] <- raster::raster(mosaicfield_list[[i]])
        raster::extent(mosaicfield_list[[i]]) <- c(0,
                                                   ncol(mosaicfield_list[[i]])*resolution,
                                                   0,
                                                   nrow(mosaicfield_list[[i]])*resolution)

        mosaicfield_list[[i]]
      })

      mosaicfields_brick <- raster::brick(mosaicfield_list)
      names(mosaicfields_brick) <- paste("Step: ", seq_along(mosaicfield_list))

      # Rescale values to 0-1
      if (rescale == TRUE) {
        mosaicfields_brick <- util_rescale(mosaicfields_brick)
      }


      mosaicfields_return$steps <- mosaicfields_brick

    }


  }

  if (isTRUE(infinit)) {

    # INFINITE STEPS:
    X <- spatstat::rLGCP("exp", 4, var=1, scale=.2, saveLambda=TRUE)
    mosaicfield_inf <- RandomFields::log(attr(X, "Lambda"))

    # coerce spatstat image to raster and set proper resolution ----
    mosaicfield_df <- as.data.frame(mosaicfield_inf)
    sp::coordinates(mosaicfield_df) <- ~ x + y
    sp::gridded(mosaicfield_df) <- TRUE
    mosaicfield_raster <- raster::raster(mosaicfield_df)
    raster::extent(mosaicfield_raster) <- c(0,
                                            ncol(mosaicfield_raster)*resolution,
                                            0,
                                            nrow(mosaicfield_raster)*resolution)

    # Rescale values to 0-1
    if (rescale == TRUE) {
      mosaicfield_raster <- util_rescale(mosaicfield_raster)
    }


    mosaicfields_return$mosaicfield_inf <- mosaicfield_raster
  }


  if(length(mosaicfields_return) == 1)  mosaicfields_return <- mosaicfields_return[[1]]

  return(mosaicfields_return)


}

# TEST STUFF
#
# X <- runifpoint(2)
# plot(dirichlet(X))
# mosaicfield_result <- rMosaicField(dirichlet(X),
#                                  rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
#
#
#
# for (i in 1:n) {
#   mosaicfield_n <- rMosaicField(dirichlet(runifpoint(2)),
#                               rnorm, dimyx=c(nCol,nRow), rgenargs=list(mean=0.5, sd=0.5))
#   mosaicfield_result <- mosaicfield_result + mosaicfield_n
#
#   ### COLLECT STEPS IN LIST
# }
