context("RandomNLM results")

# Test input ----
test_that("RandomNLM throws correct error of nCol is 0 or missing", {

  test_that("nCol is 0", {
    expect_that(randomNLM(0,1),
                throws_error("nCol' must be >= 1"))
  })


  test_that("nCol is missing", {
    expect_that(randomNLM(nRow = 1),
                throws_error())
  })

})


test_that("RandomNLM throws correct error of nRow is 0 or missing", {

  test_that("nRow is 0", {
    expect_that(randomNLM(1,0),
                throws_error("nRow' must be >= 1"))
  })


  test_that("nRow is missing", {
    expect_that(randomNLM(nCol = 1),
                throws_error())
  })

})



# Test outpout ----
test_that("RandomNLM produces the right class of output", {

  test_that("RandomNLM inherits from `RasterLayer`", {
    example_randomNLM <- randomNLM(3,3)
    expect_that(example_randomNLM, is_a("RasterLayer"))
  })


})
