# nolint start
context("nlm_distancegradient")

test_that("nlm_distancegradient behaves like it should", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_that(distance_gradient, is_a("SpatRaster"))
})



test_that("nlm_distancegradient sets origin right", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(terra::as.matrix(distance_gradient, wide = TRUE)[5, 5], 0)
})


test_that("nlm_distancegradient produces the right number of rows", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(terra::nrow(distance_gradient), 12)
})

test_that("nlm_distancegradient produces the right number of columns", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(terra::ncol(distance_gradient), 9)
})

test_that("nlm_distancegradient sets the expected extent", {
  suppressWarnings(distance_gradient <- nlm_distancegradient(ncol = 9,
                                            nrow = 12,
                                            origin = c(5, 5, 5, 5)))
  expect_equal(terra::ext(distance_gradient), terra::ext(0, 9, 0, 12))
})

# nolint end
