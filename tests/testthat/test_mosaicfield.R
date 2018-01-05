# nolint start
context("nlm_mosaicfield")

mosaic_field <- nlm_mosaicfield(ncol = 20, nrow = 30,
                                n = NA,
                                infinit = TRUE,
                                collect = FALSE)

test_that("nlm_mosaicfield behaves like it should", {
  expect_that(mosaic_field, is_a("RasterLayer"))
})

test_that("nlm_mosaicfield produces the right number of rows", {
  expect_equal(mosaic_field@nrows, 30)
})

test_that("nlm_mosaicfield produces the right number of columns", {
  expect_equal(mosaic_field@ncols, 20)
})

mosaic_field2 <- nlm_mosaicfield(ncol = 20, nrow = 30,
                                 n = 3,
                                 infinit = TRUE,
                                 collect = FALSE)

test_that("nlm_mosaicfield stores at least 2 raster when infinit true
          and n != NA", {
  expect_equal(length(mosaic_field2), 2)
})

# nolint end
