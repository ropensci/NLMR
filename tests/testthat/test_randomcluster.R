# nolint start
context("nlm_randomcluster")

suppressWarnings(random_cluster  <- nlm_randomcluster(ncol = 40, nrow = 30,
                                     neighbourhood = 4, p = 0.4))

test_that("nlm_randomcluster behaves like it should", {
  expect_that(random_cluster , is_a("RasterLayer"))
})

test_that("nlm_randomcluster produces the right number of rows", {
  expect_equal(random_cluster@nrows, 30)
})

test_that("nlm_randomcluster produces the right number of columns", {
  expect_equal(random_cluster@ncols, 40)
})

test_that("nlm_randomcluster reproduces output with user_seed", {
  skip_if_not_installed("igraph")
  cluster_a <- nlm_randomcluster(ncol = 40, nrow = 30, neighbourhood = 4,
                                 p = 0.4, user_seed = 123)
  cluster_b <- nlm_randomcluster(ncol = 40, nrow = 30, neighbourhood = 4,
                                 p = 0.4, user_seed = 123)
  expect_equal(raster::values(cluster_a), raster::values(cluster_b))
})

# nolint end
