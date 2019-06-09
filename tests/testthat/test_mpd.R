# nolint start
context("nlm_mpd")

set.seed(1)
suppressMessages(mpd_raster <- nlm_mpd(ncol = 64, nrow = 64, roughness  = 0.6))

test_that("nlm_mpd behaves like it should", {
  expect_that(mpd_raster, is_a("RasterLayer"))
})

test_that("nlm_mpd produces the right number of rows", {
  expect_equal(mpd_raster@nrows, 63)
})

test_that("nlm_mpd produces the right number of columns", {
  expect_equal(mpd_raster@ncols, 63)
})

# test_that("nlm_mpd produces the right hurst coefficient", {
#   h <- pracma::hurstexp(mpd_raster[], display = FALSE)
#   expect_equal(h$Hal, 0.6, tolerance = 0.1)
# })

# nolint end
