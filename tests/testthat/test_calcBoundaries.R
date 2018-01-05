context("calc_boundaries results")

x <- matrix(runif(100, 0, 1), 10, 10)
y <- util_w2cp(c(0.5, 0.25, 0.25))

# Test input ----
test_that("util_calc_boundaries prints error if 'x' or
          'cumulative_proportions' are missing", {
  expect_error(util_calc_boundaries(cumulative_proportions = y))
  expect_error(util_calc_boundaries(x = x))
})

# Test outpout ----
test_that("util_calc_boundaries output has correct structure", {
  expect_is(util_calc_boundaries(x, y), "numeric")
  expect_equal(length(util_calc_boundaries(x, y)), length(y))
})
