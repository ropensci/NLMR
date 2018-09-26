# nolint start
context("nlm_randomrectangularcluster")

randomrectangular_cluster <- nlm_randomrectangularcluster(ncol = 30,
                                                          nrow = 30,
                                                          minl = 5,
                                                          maxl = 10)

test_that("nlm_randomrectangularcluster behaves like it should", {
  expect_that(randomrectangular_cluster , is_a("RasterLayer"))
})

test_that("nlm_randomrectangularcluster produces the right number of rows", {
  expect_equal(randomrectangular_cluster@nrows, 30)
})

test_that("nlm_randomrectangularcluster produces the right number of columns", {
  expect_equal(randomrectangular_cluster@ncols, 30)
})

# nolint end
