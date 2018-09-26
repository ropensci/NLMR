# nolint start
context("nlm_mosaicgibbs")

nlm_mosaicgibbs  <- nlm_mosaicgibbs(ncol = 40,
                                    nrow = 30,
                                    germs = 20,
                                    R = 0.02,
                                    patch_classes = 12)

test_that("nlm_mosaicgibbs behaves like it should", {
  expect_that(nlm_mosaicgibbs , is_a("RasterLayer"))
})


test_that("nlm_mosaicgibbs produces the right number of rows", {
  expect_equal(nlm_mosaicgibbs@nrows, 30)
})

test_that("nlm_mosaicgibbs produces the right number of columns", {
  expect_equal(nlm_mosaicgibbs@ncols, 40)
})

test_that("nlm_mosaicgibbs uses the right number of patch_classes", {
  expect_equal(length(raster::unique(nlm_mosaicgibbs)), 12)
})

# nolint end
