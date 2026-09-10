# nolint start
context("nlm_mpd")

set.seed(1)
suppressWarnings(suppressMessages(mpd_raster <- nlm_mpd(ncol = 64, nrow = 64, roughness  = 0.6)))

test_that("nlm_mpd behaves like it should", {
  expect_s4_class(mpd_raster, "SpatRaster")
})

test_that("nlm_mpd produces the right number of rows", {
  expect_equal(terra::nrow(mpd_raster), 63)
})

test_that("nlm_mpd rejects invalid roughness", {
  expect_error(nlm_mpd(ncol = 10, nrow = 10, roughness = 1.5), "roughness")
})

test_that("nlm_mpd produces the right number of columns", {
  expect_equal(terra::ncol(mpd_raster), 63)
})

test_that("nlm_mpd reproduces output with user_seed", {
  raster_a <- nlm_mpd(ncol = 65, nrow = 65, roughness = 0.6, user_seed = 123)
  raster_b <- nlm_mpd(ncol = 65, nrow = 65, roughness = 0.6, user_seed = 123)

  expect_equal(terra::values(raster_a), terra::values(raster_b))
})

# test_that("nlm_mpd produces the right hurst coefficient", {
#   h <- pracma::hurstexp(mpd_raster[], display = FALSE)
#   expect_equal(h$Hal, 0.6, tolerance = 0.1)
# })

# nolint end
