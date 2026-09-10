# nolint start
context("nlm_edgegradient")

edge_gradient <- nlm_edgegradient(ncol = 9, nrow = 12)

test_that("nlm_edgegradient behaves like it should", {
  expect_that(edge_gradient, is_a("SpatRaster"))
})


test_that("nlm_edgegradient produces the right number of rows", {
  expect_equal(terra::nrow(edge_gradient), 12)
})

test_that("nlm_edgegradient produces the right number of columns", {
  expect_equal(terra::ncol(edge_gradient), 9)
})

test_that("nlm_edgegradient uses the right direction", {
  set.seed(1)
  edge_gradient <- nlm_edgegradient(ncol = 100, nrow = 100, direction = 180)
  expect_equal(terra::as.matrix(edge_gradient, wide = TRUE)[1,1], 0)
  expect_equal(terra::as.matrix(edge_gradient, wide = TRUE)[50,50], 1, tolerance = 0.011)
  expect_equal(terra::as.matrix(edge_gradient, wide = TRUE)[100,100], 0)
})

test_that("nlm_edgegradient reproduces random direction with user_seed", {
  edge_a <- nlm_edgegradient(ncol = 30, nrow = 30, direction = NA, user_seed = 123)
  edge_b <- nlm_edgegradient(ncol = 30, nrow = 30, direction = NA, user_seed = 123)
  expect_equal(terra::values(edge_a), terra::values(edge_b))
})


# nolint end
