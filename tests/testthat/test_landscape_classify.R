context("util_classify")

library(terra)

set.seed(4322)

test_that("landscape_classify returns SpatRaster for SpatRaster input", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))

  out <- landscape_classify(x, n = 3)

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:3))
})

test_that("landscape_classify rejects non-SpatRaster input", {
  x <- matrix(runif(12), nrow = 3)

  expect_error(landscape_classify(x, n = 3), "only supports SpatRaster")
})

test_that("landscape_classify respects weighting for SpatRaster", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))

  out <- landscape_classify(x, weighting = c(0.5, 0.5))

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:2))
})

test_that("landscape_classify accepts real_land with mask", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))
  real_land <- rast(ncol = 4, nrow = 3)
  values(real_land) <- rep(c(1L, 2L, 3L, 2L), length.out = ncell(real_land))

  out <- landscape_classify(x, real_land = real_land, mask_val = 1)

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:2))
  expect_true(any(is.na(values_out)))
})

test_that("landscape_classify rejects mismatched real_land geometry", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))
  real_land <- rast(ncol = 5, nrow = 3)
  values(real_land) <- rep(c(1L, 2L, 3L, 2L, 1L), length.out = ncell(real_land))

  expect_error(landscape_classify(x, real_land = real_land), "matching geometry")
})
