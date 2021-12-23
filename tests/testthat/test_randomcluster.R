# nolint start
context("nlm_randomcluster")

suppressWarnings(random_cluster  <- nlm_randomcluster(ncol = 300, nrow = 250,
                                     neighbourhood = 4, p = 0.4, ai = c(0.1, 0.3, 0.6),
                                     rescale = F))

test_that("nlm_randomcluster behaves like it should", {
  expect_that(random_cluster , is_a("SpatRaster"))
})

test_that("nlm_randomcluster produces the right number of rows", {
  expect_equal(terra::nrow(random_cluster), 250)
})

test_that("nlm_randomcluster produces the right number of columns", {
  expect_equal(terra::ncol(random_cluster), 300)
})

test_that("nlm_randomcluster produces expected values", {
  expect_equal(length(unique(terra::values(random_cluster))), 3)
})

test_that("nlm_randomcluster produces proportions within 0.05 of expected", {
  expect_equal(terra::freq(random_cluster)[,3][1] / length(terra::values(random_cluster)), 
               0.1, tolerance = 0.05)
})

test_that("nlm_randomcluster produces proportions within 0.05 of expected", {
  expect_equal(terra::freq(random_cluster)[,3][2] / length(terra::values(random_cluster)), 
               0.3, tolerance = 0.05)
})

test_that("nlm_randomcluster produces proportions within 0.05 of expected", {
  expect_equal(terra::freq(random_cluster)[,3][3] / length(terra::values(random_cluster)), 
               0.6, tolerance = 0.05)
})
# nolint end
