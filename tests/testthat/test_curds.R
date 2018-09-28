# nolint start
context("nlm_curds")

test_that("nlm_curds is a good boy", {
  curds <- nlm_curds(c(0.5, 0.3), c(6, 2))
  expect_that(curds, is_a("RasterLayer"))
  expect_equal(length(unique(curds@data@values)), 2)
})


test_that("nlm_curds with wheyed option is functional", {
  curds <- nlm_curds(c(0.5, 0.3), c(6, 2), c(0.2, 0.3))
  expect_that(curds, is_a("RasterLayer"))
  expect_equal(length(unique(curds@data@values)), 2)
})


# nolint end
