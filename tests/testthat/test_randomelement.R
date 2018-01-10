# nolint start
context("nlm_randomelement")

suppressWarnings(random_element  <- nlm_randomelement(ncol = 40, nrow = 30,
                                                      n = 25))

test_that("nlm_randomelement behaves like it should", {
  expect_that(random_element , is_a("RasterLayer"))
})

test_that("nlm_randomelement produces the right number of rows", {
  expect_equal(random_element@nrows, 30)
})

test_that("nlm_randomelement produces the right number of columns", {
  expect_equal(random_element@ncols, 40)
})

# nolint end
