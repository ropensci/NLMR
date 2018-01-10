# nolint start
context("util_classify")

x <- nlm_random(10, 10)
y <- c(0.5, 0.25, 0.25)
classified_x <- util_classify(x, y, level_names = c("Land Use 1",
                                                    "Land Use 2",
                                                    "Land Use 3"))

test_that("util_classify behaves like it should", {
  expect_that(classified_x, is_a("RasterLayer"))
})

test_that("util_classify classifies correct", {
  expect_equal(length(raster::unique(classified_x)), 3)
})

# nolint end
