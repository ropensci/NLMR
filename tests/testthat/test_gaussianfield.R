# nolint start
context("nlm_gaussianfield")

test_that("nlm_gaussianfield behaves like it should", {
  gaussian_field <- nlm_gaussianfield(ncol = 90, nrow = 30,
                                      autocorr_range = 75, mag_var = 0.4)
  expect_that(gaussian_field, is_a("RasterLayer"))
})

test_that("nlm_gaussianfield produces the right number of rows", {
  gaussian_field <- nlm_gaussianfield(ncol = 9, nrow = 12)
  expect_equal(gaussian_field@nrows, 12)
})

test_that("nlm_gaussianfield produces the right number of columns", {
  gaussian_field <- nlm_gaussianfield(ncol = 9, nrow = 12)
  expect_equal(gaussian_field@ncols, 9)
})

test_that("nlm_gaussianfield gets smoother with larger autocorr_range", {
  short_range <- nlm_gaussianfield(
    ncol = 40,
    nrow = 40,
    autocorr_range = 3,
    mag_var = 1,
    nug = 0,
    mean = 0,
    user_seed = 1,
    rescale = FALSE
  )
  long_range <- nlm_gaussianfield(
    ncol = 40,
    nrow = 40,
    autocorr_range = 20,
    mag_var = 1,
    nug = 0,
    mean = 0,
    user_seed = 1,
    rescale = FALSE
  )

  lag1_cor <- function(x) {
    m <- raster::as.matrix(x)
    stats::cor(
      c(m[-1, , drop = FALSE], m[, -1, drop = FALSE]),
      c(m[-nrow(m), , drop = FALSE], m[, -ncol(m), drop = FALSE])
    )
  }

  expect_lt(lag1_cor(short_range), lag1_cor(long_range))
})

test_that("nlm_gaussianfield nugget increases short-scale variance", {
  smooth_field <- nlm_gaussianfield(
    ncol = 40,
    nrow = 40,
    autocorr_range = 10,
    mag_var = 1,
    nug = 0,
    mean = 0,
    user_seed = 1,
    rescale = FALSE
  )
  noisy_field <- nlm_gaussianfield(
    ncol = 40,
    nrow = 40,
    autocorr_range = 10,
    mag_var = 1,
    nug = 2,
    mean = 0,
    user_seed = 1,
    rescale = FALSE
  )

  lag1_variance <- function(x) {
    m <- raster::as.matrix(x)
    dx <- m[-1, , drop = FALSE] - m[-nrow(m), , drop = FALSE]
    dy <- m[, -1, drop = FALSE] - m[, -ncol(m), drop = FALSE]

    mean(c(dx^2, dy^2), na.rm = TRUE)
  }

  expect_gt(lag1_variance(noisy_field), lag1_variance(smooth_field))
})

# nolint end
