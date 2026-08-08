# nolint start
context("nlm_mosaictess")

mosaictess  <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20)

test_that("nlm_polylands behaves like it should", {
  expect_that(mosaictess , is_a("SpatRaster"))
})


test_that("nlm_polylands produces the right number of rows", {
  expect_equal(terra::nrow(mosaictess), 30)
})

test_that("nlm_polylands produces the right number of columns", {
  expect_equal(terra::ncol(mosaictess), 40)
})


test_that("nlm_polylands uses the right number of germs", {
  expect_equal(length(unique(terra::values(mosaictess))), 20)
})

test_that("nlm_mosaictess reproduces output with user_seed", {
  tess_a <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20, user_seed = 123)
  tess_b <- nlm_mosaictess(ncol = 40, nrow = 30, germs = 20, user_seed = 123)
  expect_equal(terra::values(tess_a), terra::values(tess_b))
})

# nolint end
