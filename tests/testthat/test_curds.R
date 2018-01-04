# nolint start
context("nlm_curds")

test_that("nlm_random inherits from `RasterLayer`", {
  curds <- nlm_curds(c(0.5, 0.3), c(6, 2))
  expect_that(curds, is_a("RasterLayer"))
})
