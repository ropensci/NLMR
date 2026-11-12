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

test_that("nlm_neigh validates category proportions and cell counts", {
  neigh <- function(p_neigh = 1, p_empty = 1, proportions = NA) {
    nlm_neigh(ncol = 5, nrow = 2, p_neigh = p_neigh, p_empty = p_empty,
              categories = 3, proportions = proportions, rescale = FALSE,
              user_seed = 1)
  }

  expect_error(neigh(p_empty = 0), "greater than zero")
  expect_error(neigh(p_neigh = 0), "greater than zero")
  expect_error(neigh(proportions = c(0.5, 0.5)), "length 3")
  expect_error(neigh(proportions = c(-0.1, 0.5, 0.6)), ">= 0")
  expect_error(neigh(proportions = c(0.2, 0.2, 0.2)), "sum to one")

  result <- neigh(proportions = c(0.34, 0.33, 0.33))
  counts <- table(factor(terra::values(result), levels = 0:2))
  expect_equal(as.integer(counts), c(4L, 3L, 3L))

  expect_equal(
    terra::values(neigh(proportions = c(1L, 0L, 0L))),
    terra::values(neigh(proportions = c(1, 0, 0)))
  )
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
