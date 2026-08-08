# nolint start
context("nlm_percolation")

percolation  <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5)

test_that("nlm_percolation behaves like it should", {
  expect_that(percolation , is_a("SpatRaster"))
})

test_that("nlm_percolation produces the right number of rows", {
  expect_equal(terra::nrow(percolation), 12)
})

test_that("nlm_percolation produces the right number of columns", {
  expect_equal(terra::ncol(percolation), 9)
})

test_that("nlm_percolation produces the right number of values", {
  expect_equal(length(unique(terra::values(percolation))), 2)
})

test_that("nlm_percolation reproduces output with user_seed", {
  perc_a <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5, user_seed = 123)
  perc_b <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5, user_seed = 123)
  expect_equal(raster::values(perc_a), raster::values(perc_b))
})

# nolint end
