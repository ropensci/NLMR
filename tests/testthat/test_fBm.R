# nolint start
context("nlm_fBm")

fbm_raster <- nlm_fbm(ncol = 9, nrow = 12, fract_dim = 0.5)

test_that("nlm_fBm behaves like it should", {
  expect_that(fbm_raster, is_a("RasterLayer"))
})

test_that("nlm_fBm produces the right number of rows", {
  expect_equal(fbm_raster@nrows, 12)
})

test_that("nlm_fBm produces the right number of columns", {
  expect_equal(fbm_raster@ncols, 9)
})

# test_that("nlm_fBm produces the right hurst coefficient", {
#   h <- pracma::hurstexp(fbm_raster[], display = FALSE)
#   expect_equal(h$Hal, 0.5, tolerance = 0.2)
# })

# nolint end
