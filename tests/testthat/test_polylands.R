# nolint start
context("nlm_polylands")

poly_lands  <- nlm_polylands(ncol = 40, nrow = 30, germs = 20)

test_that("nlm_polylands behaves like it should", {
  expect_that(poly_lands , is_a("RasterLayer"))
})


test_that("nlm_polylands produces the right number of rows", {
  expect_equal(poly_lands@nrows, 30)
})

test_that("nlm_polylands produces the right number of columns", {
  expect_equal(poly_lands@ncols, 40)
})


test_that("nlm_polylands uses the right number of germs", {
  expect_equal(length(raster::unique(poly_lands)), 20)
})

# nolint end
