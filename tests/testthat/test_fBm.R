# nolint start
context("nlm_fBm")

test_that("nlm_fBm behaves like it should", {
  fBm_raster <- nlm_fBm(ncol = 20, nrow = 30, H = 0.5)
  expect_that(fBm_raster, is_a("RasterLayer"))
})

test_that("nlm_fBm produces the right number of rows", {
  fBm_raster <- nlm_fBm(ncol = 9, nrow = 12)
  expect_equal(fBm_raster@nrows, 12)
})

test_that("nlm_fBm produces the right number of columns", {
  fBm_raster <- nlm_fBm(ncol = 9, nrow = 12)
  expect_equal(fBm_raster@ncols, 9)
})
# nolint end
