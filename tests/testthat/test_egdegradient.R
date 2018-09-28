# nolint start
context("nlm_edgegradient")

edge_gradient <- nlm_edgegradient(ncol = 9, nrow = 12)

test_that("nlm_edgegradient behaves like it should", {
  expect_that(edge_gradient, is_a("RasterLayer"))
})


test_that("nlm_edgegradient produces the right number of rows", {
  expect_equal(edge_gradient@nrows, 12)
})

test_that("nlm_edgegradient produces the right number of columns", {
  expect_equal(edge_gradient@ncols, 9)
})

test_that("nlm_edgegradient uses the right direction", {
  set.seed(1)
  edge_gradient <- nlm_edgegradient(ncol = 100, nrow = 100, direction = 180)
  expect_equal(raster::as.matrix(edge_gradient)[1,1], 0)
  expect_equal(raster::as.matrix(edge_gradient)[50,50], 1, tolerance=0.011)
  expect_equal(raster::as.matrix(edge_gradient)[100,100], 0)
})


# nolint end
