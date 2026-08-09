context("util_classify")

library(terra)

set.seed(4322)

test_that("util_classify returns SpatRaster for SpatRaster input", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))

  out <- util_classify(x, n = 3)

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:3))
})

test_that("util_classify returns RasterLayer for RasterLayer input", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))
  x_raster <- raster::raster(x)

  out <- util_classify(x_raster, n = 3)

  expect_true(inherits(out, "RasterLayer"))
  values_out <- raster::values(out)
  expect_true(all(is.na(values_out) | values_out %in% 1:3))
})

test_that("util_classify respects weighting for SpatRaster", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))

  out <- util_classify(x, weighting = c(0.5, 0.5))

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:2))
})

test_that("util_classify accepts real_land as RasterLayer with mask", {
  x <- rast(ncol = 4, nrow = 3)
  values(x) <- runif(ncell(x))
  real_land <- rast(ncol = 4, nrow = 3)
  values(real_land) <- rep(c(1L, 2L, 3L, 2L), length.out = ncell(real_land))
  real_land_raster <- raster::raster(real_land)

  out <- util_classify(x, real_land = real_land_raster, mask_val = 1)

  expect_true(inherits(out, "SpatRaster"))
  values_out <- as.vector(terra::values(out, mat = FALSE))
  expect_true(all(is.na(values_out) | values_out %in% 1:2))
  expect_true(any(is.na(values_out)))
})
