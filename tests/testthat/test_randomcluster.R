# nolint start
context("nlm_randomcluster")

suppressWarnings(random_cluster  <- nlm_randomcluster(ncol = 40, nrow = 30,
                                     neighbourhood = 4, p = 0.4))

test_that("nlm_randomcluster behaves like it should", {
  expect_s4_class(random_cluster, "SpatRaster")
})

test_that("nlm_randomcluster produces the right number of rows", {
  expect_equal(terra::nrow(random_cluster), 30)
})

test_that("nlm_randomcluster produces the right number of columns", {
  expect_equal(terra::ncol(random_cluster), 40)
})

test_that("nlm_randomcluster reproduces output with user_seed", {
  skip_if_not_installed("igraph")
  cluster_a <- nlm_randomcluster(ncol = 40, nrow = 30, neighbourhood = 4,
                                 p = 0.4, user_seed = 123)
  cluster_b <- nlm_randomcluster(ncol = 40, nrow = 30, neighbourhood = 4,
                                 p = 0.4, user_seed = 123)
  expect_equal(terra::values(cluster_a), terra::values(cluster_b))
})

# nolint end
