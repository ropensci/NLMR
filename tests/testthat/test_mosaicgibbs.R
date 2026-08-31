# nolint start
context("nlm_mosaicgibbs")

nlm_mosaicgibbs  <- nlm_mosaicgibbs(ncol = 40,
                                    nrow = 30,
                                    germs = 20,
                                    R = 0.02,
                                    patch_classes = 12)

test_that("nlm_mosaicgibbs behaves like it should", {
  expect_s4_class(nlm_mosaicgibbs, "SpatRaster")
})


test_that("nlm_mosaicgibbs produces the right number of rows", {
  expect_equal(terra::nrow(nlm_mosaicgibbs), 30)
})

test_that("nlm_mosaicgibbs produces the right number of columns", {
  expect_equal(terra::ncol(nlm_mosaicgibbs), 40)
})

test_that("nlm_mosaicgibbs uses the right number of patch_classes", {
  expect_equal(length(unique(stats::na.omit(terra::values(nlm_mosaicgibbs)))), 12)
})

test_that("nlm_mosaicgibbs reproduces output with user_seed", {
  gibbs_a <- nlm_mosaicgibbs(ncol = 40, nrow = 30, germs = 20, R = 0.02,
                             patch_classes = 12, user_seed = 123)
  gibbs_b <- nlm_mosaicgibbs(ncol = 40, nrow = 30, germs = 20, R = 0.02,
                             patch_classes = 12, user_seed = 123)
  expect_equal(terra::values(gibbs_a), terra::values(gibbs_b))
})

# nolint end
