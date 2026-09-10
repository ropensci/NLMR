# nolint start
context("nlm_planargradient")

planar_gradient <- nlm_planargradient(ncol = 9, nrow = 12)

test_that("nlm_planargradient behaves like it should", {
  expect_s4_class(planar_gradient, "SpatRaster")
})


test_that("nlm_planargradient produces the right number of rows", {
  expect_equal(terra::nrow(planar_gradient), 12)
})

test_that("nlm_planargradient produces the right number of columns", {
  expect_equal(terra::ncol(planar_gradient), 9)
})

test_that("nlm_planargradient uses the right direction", {
  set.seed(1)
  planar_gradient <- nlm_planargradient(ncol = 80, nrow = 100, direction = 180)
  planar_matrix <- matrix(terra::values(planar_gradient), nrow = 100, ncol = 80, byrow = TRUE)
  expect_equal(planar_matrix[1, 1], 0)
  expect_equal(planar_matrix[50, 50], 0.5, tolerance = 0.011)
  expect_equal(planar_matrix[100, 80], 1)
})

test_that("nlm_planargradient reproduces random direction with user_seed", {
  planar_a <- nlm_planargradient(ncol = 80, nrow = 100, direction = NA, user_seed = 123)
  planar_b <- nlm_planargradient(ncol = 80, nrow = 100, direction = NA, user_seed = 123)
  expect_equal(terra::values(planar_a), terra::values(planar_b))
})

# nolint end
