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


## test option 2 ----


poly_lands2  <- nlm_polylands(ncol = 40,
                             nrow = 30,
                             germs = 20,
                             option = 2,
                             g = 0.5,
                             R = 0.02,
                             patch_classes = 12)

test_that("nlm_polylands behaves like it should", {
  expect_that(poly_lands2 , is_a("RasterLayer"))
})


test_that("nlm_polylands produces the right number of rows", {
  expect_equal(poly_lands2@nrows, 30)
})

test_that("nlm_polylands produces the right number of columns", {
  expect_equal(poly_lands2@ncols, 40)
})


test_that("nlm_polylands uses the right number of germs", {
  expect_equal(length(raster::unique(poly_lands2)), 12)
})


# nolint end
