# nolint start
context("util_w2cp")

test_that("basic functionality", {
  expect_error(util_w2cp(c(0.2, 0.4, 0.6, 0.9)), NA)
})


test_that("basic functionality", {
  expect_equal(length(util_w2cp(c(0.2, 0.4, 0.6, 0.9))), 4)
})

# nolint end
