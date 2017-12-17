# nolint start
context("nlm_random results")

# Test input ----
test_that("nlm_random throws correct error of nCol is 0 or missing", {
  test_that("nCol is 0 throws an error", {
    expect_that(
      nlm_random(0, 1),
      throws_error("Assertion on 'nCol' failed: Must be >= 1.")
    )
  })


  test_that("nCol is missing", {
    expect_that(
      nlm_random(nRow = 1),
      throws_error()
    )
  })
})


test_that("nlm_random throws correct error of nRow is 0 or missing", {
  test_that("nRow is 0", {
    expect_that(
      nlm_random(1, 0),
      throws_error("Assertion on 'nRow' failed: Must be >= 1.")
    )
  })


  test_that("nRow is missing", {
    expect_that(
      nlm_random(nCol = 1),
      throws_error()
    )
  })
})

# Test outpout ----

test_that("nlm_random inherits from `RasterLayer`", {
  example_nlm_random <- nlm_random(3, 3)
  expect_that(example_nlm_random, is_a("RasterLayer"))
})


test_that("nlm_random produces the right dimensions", {
  example_nlm_random <- nlm_random(3, 3)

  test_that("nlm_random produces the correct number of columns", {
    expect_that(example_nlm_random@ncols, equals(3))
  })

  test_that("nlm_random produces the correct number of columns", {
    expect_that(example_nlm_random@nrows, equals(3))
  })
})

test_that("nlm_random produces more than 0 values", {
  example_nlm_random <- nlm_random(3, 3)
  expect_that(length(example_nlm_random@data@values) == 0, is_false())
})

test_that("nlm_random produces values with a uniform distribution", {
  example_nlm_random <- nlm_random(10, 10, rescale = FALSE)
  example_nlm_random_test <- chisq.test(example_nlm_random[])


  expect_that(example_nlm_random_test$p.value == 1, is_true())
})
# nolint end
