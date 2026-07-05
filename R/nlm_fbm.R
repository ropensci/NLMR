#' nlm_fbm
#'
#' @description Creates a two-dimensional fractional Brownian motion neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#'  Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#'  Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param fract_dim [\code{numerical(1)}]\cr
#' The fractal dimension of the process (0,2)
#' @param user_seed [\code{numerical(1)}]\cr
#'  Set random seed for the simulation
#' @param rescale [\code{numeric(1)}]\cr
#'  If \code{TRUE} (default), the values are rescaled between 0-1.
#' @param ... Unused
#'
#'
#' @details
#' Neutral landscapes are generated using fractional Brownian motion,
#'  an extension of Brownian motion in which the amount of correlation between
#'   steps is controlled by \code{frac_dim}. A high value of \code{frac_dim} produces a
#'    relatively smooth, correlated surface while a low value produces a rough, uncorrelated one.
#'
#' @return character(1) Temporary maintenance message.
#'
#' @examples
#' # simulate fractional brownian motion
#' fbm_raster <- nlm_fbm(ncol = 20, nrow = 30, fract_dim = 0.8)
#'
#' \dontrun{
#'
#' # visualize the NLM
#' raster::plot(fbm_raster)
#'
#' }
#'
#' @references
#' Travis, J.M.J. & Dytham, C. (2004). A method for simulating patterns of
#' habitat availability at static and dynamic range margins. \emph{Oikos} , 104, 410–416.
#'
#' Martin Schlather, Alexander Malinowski, Peter J. Menck, Marco Oesting,
#' Kirstin Strokorb (2015). nlm_fBm. \emph{Journal of Statistical
#' Software}, 63(8), 1-25. URL http://www.jstatsoft.org/v63/i08/.
#'
#' @aliases nlm_fbm
#' @rdname nlm_fbm
#'
#' @export
#'

nlm_fbm <- function(ncol,
                    nrow,
                    resolution = 1,
                    fract_dim = 1,
                    user_seed = NULL,
                    rescale = TRUE,
                    ...) {
  # Previous post-RandomFields implementation kept for reference:
  # checkmate::assert_count(ncol, positive = TRUE)
  # checkmate::assert_count(nrow, positive = TRUE)
  # checkmate::assert_numeric(resolution, lower = 0)
  # checkmate::assert_number(fract_dim, lower = 0, upper = 2)
  # checkmate::assert_true(fract_dim > 0)
  # checkmate::assert_logical(rescale)
  #
  # fbm_simu <- simulate_fbm(
  #   nrow = nrow,
  #   ncol = ncol,
  #   fract_dim = fract_dim,
  #   seed = user_seed
  # )
  #
  # fbm_raster <- raster::raster(fbm_simu)
  # raster::extent(fbm_raster) <- c(
  #   0, ncol(fbm_raster) * resolution,
  #   0, nrow(fbm_raster) * resolution
  # )
  #
  # if (isTRUE(rescale)) fbm_raster <- util_rescale(fbm_raster)
  # fbm_raster

  message("Function nlm_fbm is currently under disabled. We are working on reimplementation of this function.")
}

simulate_fbm <- function(nrow, ncol, fract_dim, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  alpha <- fract_dim
  if (alpha >= 2 - sqrt(.Machine$double.eps)) {
    field <- simulate_fbm_linear_limit(nrow, ncol)
  } else {
    field <- simulate_fbm_spectral(nrow, ncol, alpha)
  }

  field <- field - mean(field)
  field / fbm_unit_increment_sd(field)
}

simulate_fbm_linear_limit <- function(nrow, ncol) {
  row_coord <- seq.int(0, nrow - 1L)
  col_coord <- seq.int(0, ncol - 1L)
  slopes <- stats::rnorm(2)

  outer(
    row_coord,
    col_coord,
    function(i, j) slopes[1] * i + slopes[2] * j
  )
}

simulate_fbm_spectral <- function(nrow, ncol, alpha) {
  fx <- c(0:floor(ncol / 2), -floor((ncol - 1) / 2):-1)
  fy <- c(0:floor(nrow / 2), -floor((nrow - 1) / 2):-1)

  kx <- matrix(rep(fx, each = nrow), nrow, ncol)
  ky <- matrix(rep(fy, times = ncol), nrow, ncol)

  # A finite-grid 1/f^beta spectrum avoids the directional artifacts that
  # appear when reconstructing the surface from axis-aligned lattice sums.
  spectrum <- pmax(kx^2 + ky^2, 1)^(-(alpha + 1) / 2)
  spectrum[1, 1] <- 0

  z <- matrix(stats::rnorm(nrow * ncol), nrow, ncol) +
    1i * matrix(stats::rnorm(nrow * ncol), nrow, ncol)

  Re(stats::fft(sqrt(spectrum) * z, inverse = TRUE)) / sqrt(nrow * ncol)
}

fbm_unit_increment_sd <- function(field) {
  diffs <- list()

  if (nrow(field) > 1L) {
    diffs[[length(diffs) + 1L]] <-
      field[-1, , drop = FALSE] - field[-nrow(field), , drop = FALSE]
  }

  if (ncol(field) > 1L) {
    diffs[[length(diffs) + 1L]] <-
      field[, -1, drop = FALSE] - field[, -ncol(field), drop = FALSE]
  }

  if (length(diffs) == 0L) {
    return(1)
  }

  stats::sd(unlist(diffs, use.names = FALSE))
}


# nlm_fbm <- function(ncol,
#                     nrow,
#                     resolution = 1,
#                     fract_dim = 1,
#                     user_seed = NULL,
#                     rescale = TRUE,
#                     ...) {

#   hasData()

#   # Check function arguments ----
#   checkmate::assert_count(ncol, positive = TRUE)
#   checkmate::assert_count(nrow, positive = TRUE)
#   checkmate::assert_numeric(resolution)
#   checkmate::assert_numeric(fract_dim)
#   checkmate::assert_true(fract_dim > 0)
#   checkmate::assert_true(fract_dim <= 2)
#   checkmate::assert_logical(rescale)

#   # specify RandomFields options ----
#   RandomFields::RFoptions(cPrintlevel = 0)
#   RandomFields::RFoptions(spConform = FALSE)
#   RandomFields::RFoptions(...)

#   # set RF seed ----
#   RandomFields::RFoptions(seed = user_seed)

#   # formulate and simulate fBm model
#   fbm_model <- RandomFields::RMfbm(
#     alpha = fract_dim)
#   fbm_simu <- RandomFields::RFsimulate(fbm_model,
#                                        # fBm changes x and y?
#                                        y = seq.int(0, length.out = ncol),
#                                        x = seq.int(0, length.out = nrow),
#                                        grid = TRUE)


#   # transform simulation into raster ----
#   fbm_raster <- raster::raster(fbm_simu)


#   # specify extent and resolution ----
#   raster::extent(fbm_raster) <- c(
#     0,
#     ncol(fbm_raster) * resolution,
#     0,
#     nrow(fbm_raster) * resolution
#   )

#   # Rescale values to 0-1 ----
#   if (rescale == TRUE) {
#     fbm_raster <- util_rescale(fbm_raster)
#   }

#   return(fbm_raster)

# }
