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

# nolint end
