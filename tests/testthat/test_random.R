context("RandomNLM results")

# Test input ----
test_that("RandomNLM throws correct error of nCol is 0 or missing", {
  test_that("nCol is 0 throws an error", {
    expect_that(randomNLM(0, 1),
                throws_error("Assertion on 'nCol' failed: Must be >= 1."))
  })


  test_that("nCol is missing", {
    expect_that(randomNLM(nRow = 1),
                throws_error())
  })

})


test_that("RandomNLM throws correct error of nRow is 0 or missing", {
  test_that("nRow is 0", {
    expect_that(randomNLM(1, 0),
                throws_error("Assertion on 'nRow' failed: Must be >= 1."))
  })


  test_that("nRow is missing", {
    expect_that(randomNLM(nCol = 1),
                throws_error())
  })

})

# Test outpout ----

test_that("RandomNLM inherits from `RasterLayer`", {
  example_randomNLM <- randomNLM(3, 3)
  expect_that(example_randomNLM, is_a("RasterLayer"))
})


test_that("RandomNLM produces the right dimensions", {
  example_randomNLM <- randomNLM(3, 3)

  test_that("RandomNLM produces the correct number of columns", {
    expect_that(example_randomNLM@ncols, equals(3))
  })

  test_that("RandomNLM produces the correct number of columns", {
    expect_that(example_randomNLM@nrows, equals(3))
  })
})

test_that("RandomNLM produces more than 0 values", {
  example_randomNLM <- randomNLM(3, 3)
  expect_that(length(example_randomNLM@data@values) == 0, is_false())
})

test_that("RandomNLM produces values with a uniform distribution", {
  example_randomNLM <- randomNLM(10, 10, rescale = FALSE)
  example_randomNLM_test <- chisq.test(example_randomNLM[])


  expect_that(example_randomNLM_test$p.value == 1, is_true())
})

