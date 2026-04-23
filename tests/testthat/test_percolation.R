# nolint start
context("nlm_percolation")

percolation  <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5)

test_that("nlm_percolation behaves like it should", {
  expect_that(percolation , is_a("RasterLayer"))
})

test_that("nlm_percolation produces the right number of rows", {
  expect_equal(percolation@nrows, 12)
})

test_that("nlm_percolation produces the right number of columns", {
  expect_equal(percolation@ncols, 9)
})

test_that("nlm_percolation produces the right number of columns", {
  expect_equal(length(unique(percolation@data@values)), 2)
})

test_that("nlm_percolation reproduces output with user_seed", {
  perc_a <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5, user_seed = 123)
  perc_b <- nlm_percolation(ncol = 9, nrow = 12, prob = 0.5, user_seed = 123)
  expect_equal(raster::values(perc_a), raster::values(perc_b))
})

# nolint end
