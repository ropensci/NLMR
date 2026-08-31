# nolint start
context("nlm_curds")

test_that("nlm_curds is a good boy", {
  curds <- nlm_curds(c(0.5, 0.3), c(6, 2))
  expect_s4_class(curds, "SpatRaster")
  expect_equal(length(unique(stats::na.omit(terra::values(curds)))), 2)
})


test_that("nlm_curds with wheyed option is functional", {
  curds <- nlm_curds(c(0.5, 0.3), c(6, 2), c(0.2, 0.3))
  expect_s4_class(curds, "SpatRaster")
  expect_equal(length(unique(stats::na.omit(terra::values(curds)))), 2)
})

test_that("nlm_curds reproduces output with user_seed", {
  curds_a <- nlm_curds(c(0.5, 0.3), c(6, 2), user_seed = 123)
  curds_b <- nlm_curds(c(0.5, 0.3), c(6, 2), user_seed = 123)
  expect_equal(terra::values(curds_a), terra::values(curds_b))
})


# nolint end
