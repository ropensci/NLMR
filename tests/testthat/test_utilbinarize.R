# nolint start
context("theme_nlm")

rnd_bin <- util_binarize(nlm_random(10, 10), c(0.3, 0.5, 0.7, 0.9))

test_that("basic functionality", {
  expect_error(util_binarize(nlm_random(10, 10), c(0.3, 0.5, 0.7, 0.9)), NA)
})


test_that("right number of layers in the brick", {
  expect_equal(raster::nlayers(rnd_bin), 4)
})

test_that("binary maps in every layer", {
  expect_equal(length(raster::unique(rnd_bin[[1]])), 2)
  expect_equal(length(raster::unique(rnd_bin[[2]])), 2)
  expect_equal(length(raster::unique(rnd_bin[[3]])), 2)
  expect_equal(length(raster::unique(rnd_bin[[4]])), 2)
})

test_that("right number of layers in the brick", {
  expect_equal(raster::nlayers(util_binarize(nlm_random(10, 10), c(0.3))), 1)
})


# nolint end
