# nolint start
context("util_rescale")

rndMap <- util_rescale(nlm_random(10, 10,  rescale = FALSE))

test_that("basic functionality", {
  expect_error(util_rescale(nlm_random(10, 10,  rescale = FALSE)), NA)
})

test_that("util_plot behaves like it should", {
  expect_equal(raster::minValue(rndMap),0)
  expect_equal(raster::maxValue(rndMap),1)
})

# nolint end
