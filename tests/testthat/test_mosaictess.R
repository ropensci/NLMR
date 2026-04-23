# nolint start
context("nlm_mosaictess")

mosaictess  <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20)

test_that("nlm_polylands behaves like it should", {
  expect_that(mosaictess , is_a("RasterLayer"))
})


test_that("nlm_polylands produces the right number of rows", {
  expect_equal(mosaictess@nrows, 30)
})

test_that("nlm_polylands produces the right number of columns", {
  expect_equal(mosaictess@ncols, 40)
})


test_that("nlm_polylands uses the right number of germs", {
  expect_equal(length(raster::unique(mosaictess)), 20)
})

test_that("nlm_mosaictess reproduces output with user_seed", {
  tess_a <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20, user_seed = 123)
  tess_b <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20, user_seed = 123)
  expect_equal(raster::values(tess_a), raster::values(tess_b))
})

# nolint end
