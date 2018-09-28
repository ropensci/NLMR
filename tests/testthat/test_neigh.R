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
  expect_that(neigh_raster, is_a("RasterLayer"))
})
test_that("nlm_neigh produces the right number of rows", {
  expect_equal(neigh_raster@nrows, 20)
})

test_that("nlm_neigh produces the right number of columns", {
  expect_equal(neigh_raster@ncols, 20)
})

test_that("nlm_neigh produces the right number of categories", {
  expect_equal(length(unique(neigh_raster@data@values)), 5)
})

neigh_raster  <- nlm_neigh(ncol = 20,
                           nrow = 20,
                           p_neigh = 0.1,
                           p_empty = 0.3,
                           categories = 5,
                           neighbourhood = 8
)

test_that("nlm_neigh behaves like it should", {
  expect_that(neigh_raster, is_a("RasterLayer"))
})
test_that("nlm_neigh produces the right number of rows", {
  expect_equal(neigh_raster@nrows, 20)
})

test_that("nlm_neigh produces the right number of columns", {
  expect_equal(neigh_raster@ncols, 20)
})

test_that("nlm_neigh produces the right number of categories", {
  expect_equal(length(unique(neigh_raster@data@values)), 5)
})

# nolint end
