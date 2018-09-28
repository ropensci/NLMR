# nolint start
context("nlm_distancegradient")

test_that("nlm_distancegradient behaves like it should", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_that(distance_gradient, is_a("RasterLayer"))
})



test_that("nlm_distancegradient sets origin right", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(raster::as.matrix(distance_gradient)[5, 5], 0)
})


test_that("nlm_distancegradient produces the right number of rows", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(distance_gradient@nrows, 12)
})

test_that("nlm_distancegradient produces the right number of columns", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(distance_gradient@ncols, 9)
})

# nolint end
