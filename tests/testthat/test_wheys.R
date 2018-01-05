# nolint start
context("nlm_wheys")

test_that("nlm_wheys is a good boy", {
  wheys <- nlm_wheys(c(0.5, 0.3), c(6, 2), c(0.2, 0.3))
  expect_that(wheys, is_a("RasterLayer"))
  expect_equal(length(raster::unique(wheys)), 2)
})

# nolint end
