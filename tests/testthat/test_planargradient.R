# nolint start
context("nlm_planargradient")

planar_gradient <- nlm_planargradient(ncol = 9, nrow = 12)

test_that("nlm_planargradient behaves like it should", {
  expect_that(planar_gradient, is_a("RasterLayer"))
})


test_that("nlm_planargradient produces the right number of rows", {
  expect_equal(planar_gradient@nrows, 12)
})

test_that("nlm_planargradient produces the right number of columns", {
  expect_equal(planar_gradient@ncols, 9)
})

test_that("nlm_planargradient uses the right direction", {
  set.seed(1)
  planar_gradient <- nlm_planargradient(ncol = 80, nrow = 100, direction = 180)
  expect_equal(raster::as.matrix(planar_gradient)[1,1], 0)
  expect_equal(raster::as.matrix(planar_gradient)[50,50], 0.5, tolerance=0.011)
  expect_equal(raster::as.matrix(planar_gradient)[100,80], 1)
})

# nolint end
