# nolint start
context("nlm_random")

test_that("nlm_random inherits from `RasterLayer`", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_that(example_nlm_random, is_a("RasterLayer"))
})

test_that("nlm_random produces the correct number of columns", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_equal(example_nlm_random@ncols, 5)
})

test_that("nlm_random produces the correct number of columns", {
  example_nlm_random <- nlm_random(ncol = 5, nrow = 3)
  expect_equal(example_nlm_random@nrows, 3)
})

test_that("nlm_random produces more than 0 values", {
  example_nlm_random <- nlm_random(3, 3)
  expect_that(length(example_nlm_random@data@values) == 0, is_false())
})

test_that("nlm_random produces values with a uniform distribution", {
  example_nlm_random <- nlm_random(100, 100, rescale = FALSE)
  suppressWarnings(example_nlm_random_test <- chisq.test(example_nlm_random[]))
  expect_that(example_nlm_random_test$p.value == 1, is_true())
})
# nolint end
