# nolint start
context("nlm_random")

test_that("nlm_random inherits from `SpatRaster`", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_that(example_nlm_random, is_a("SpatRaster"))
})

test_that("nlm_random produces the correct number of columns", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_equal(terra::ncol(example_nlm_random), 5)
})

test_that("nlm_random produces the correct number of rows", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_equal(terra::nrow(example_nlm_random), 3)
})

test_that("nlm_random produces more than 0 values", {
  example_nlm_random <- nlm_random(3, 3)
  expect_false(terra::ncell(example_nlm_random) == 0)
})

test_that("nlm_random produces values with a uniform distribution", {
  example_nlm_random <- nlm_random(100, 100, rescale = FALSE)
  suppressWarnings(example_nlm_random_test <- chisq.test(example_nlm_random[]))
  expect_true(example_nlm_random_test$p.value == 1)
})

test_that("nlm_random reproduces output with user_seed", {
  random_a <- nlm_random(ncol = 20, nrow = 20, user_seed = 123)
  random_b <- nlm_random(ncol = 20, nrow = 20, user_seed = 123)
  expect_equal(raster::values(random_a), raster::values(random_b))
})
# nolint end
