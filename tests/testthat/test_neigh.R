# nolint start
context("nlm_neigh")

neigh_raster  <- nlm_neigh(ncol = 20,
                           nrow = 20,
                           p_neigh = 0.1,
                           p_empty = 0.3,
                           categories = 5,
                           neighbourhood = 4
                           )

test_that("nlm_neigh behaves like it should", {
  expect_s4_class(neigh_raster, "SpatRaster")
})
test_that("nlm_neigh produces the right number of rows", {
  expect_equal(terra::nrow(neigh_raster), 20)
})

test_that("nlm_neigh produces the right number of columns", {
  expect_equal(terra::ncol(neigh_raster), 20)
})

test_that("nlm_neigh produces the right number of categories", {
  expect_equal(length(unique(stats::na.omit(terra::values(neigh_raster)))), 5)
})

test_that("nlm_neigh reproduces output with user_seed", {
  neigh_a <- nlm_neigh(ncol = 20, nrow = 20, p_neigh = 0.1, p_empty = 0.3,
                       categories = 5, neighbourhood = 4, user_seed = 123)
  neigh_b <- nlm_neigh(ncol = 20, nrow = 20, p_neigh = 0.1, p_empty = 0.3,
                       categories = 5, neighbourhood = 4, user_seed = 123)
  expect_equal(terra::values(neigh_a), terra::values(neigh_b))
})

neigh_raster  <- nlm_neigh(ncol = 20,
                           nrow = 20,
                           p_neigh = 0.1,
                           p_empty = 0.3,
                           categories = 5,
                           neighbourhood = 8
)

test_that("nlm_neigh behaves like it should", {
  expect_s4_class(neigh_raster, "SpatRaster")
})
test_that("nlm_neigh produces the right number of rows", {
  expect_equal(terra::nrow(neigh_raster), 20)
})

test_that("nlm_neigh produces the right number of columns", {
  expect_equal(terra::ncol(neigh_raster), 20)
})

test_that("nlm_neigh produces the right number of categories", {
  expect_equal(length(unique(stats::na.omit(terra::values(neigh_raster)))), 5)
})

# nolint end
