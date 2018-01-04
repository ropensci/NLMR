context("calc_boundaries results")

x <- matrix(runif(100, 0, 1), 10, 10)
y <- NLMR::w2cp(c(0.5, 0.25, 0.25))

# Test input ----
test_that("calc_boundaries prints error if 'x' or
          'cumulative_proportions' are missing", {
  expect_error(calc_boundaries(cumulative_proportions = y))
  expect_error(calc_boundaries(x = x))
})

# Test outpout ----
test_that("calc_boundaries output has correct structure", {
  expect_is(calc_boundaries(x, y), "numeric")
  expect_equal(length(calc_boundaries(x, y)), length(y))
})
