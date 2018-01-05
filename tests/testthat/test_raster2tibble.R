# nolint start
context("util_raster2tibble")

rndMap <- nlm_random(16, 9)
maptib <- util_raster2tibble(rndMap)

test_that("basic functionality", {
  expect_error(util_raster2tibble(rndMap), NA)
})

test_that("util_plot behaves like it should", {
  expect_equal(class(maptib), c("tbl_df", "tbl", "data.frame"))
})

# nolint end
