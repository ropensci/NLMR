# nolint start
context("nlm_mosaicfield")

mosaic_field <- nlm_mosaicfield(
  ncol = 20,
  nrow = 30,
  n = 3,
  infinit = TRUE,
  collect = FALSE
)

test_that("nlm_mosaicfield behaves like it should", {
  expect_s4_class(mosaic_field$mosaicfield_raster, "SpatRaster")
})

test_that("nlm_mosaicfield produces the right number of rows", {
  expect_equal(terra::nrow(mosaic_field$mosaicfield_inf), 30)
})

test_that("nlm_mosaicfield produces the right number of columns", {
  expect_equal(terra::ncol(mosaic_field$mosaicfield_raster), 20)
})

test_that("nlm_mosaicfield stores at least 2 raster when infinit true
          and n != NA",
          {
            expect_equal(length(mosaic_field), 2)
          })

mosaic_field2 <- nlm_mosaicfield(
  ncol = 20,
  nrow = 30,
  n = 3,
  infinit = TRUE,
  collect = TRUE
)

test_that("nlm_mosaicfield stores at least 3 raster when infinit true
          and n != NA and collect true",
          {
            expect_equal(length(mosaic_field2), 3)
          })

test_that("nlm_mosaicfield stores collection as rasterbrick",
          {
            expect_s4_class(mosaic_field2$steps, "SpatRaster")
          })

test_that("nlm_mosaicfield collects named cumulative steps", {
  mosaic_2 <- nlm_mosaicfield(
    ncol = 10, nrow = 10, n = 2, collect = TRUE,
    rescale = FALSE, user_seed = 123
  )
  mosaic_3 <- nlm_mosaicfield(
    ncol = 10, nrow = 10, n = 3, collect = TRUE,
    rescale = FALSE, user_seed = 123
  )

  expect_equal(terra::nlyr(mosaic_3$steps), 3)
  expect_equal(names(mosaic_3$steps), paste0("Step: ", 1:3))
  expect_equal(
    unname(terra::values(mosaic_3$steps[[2]])),
    unname(terra::values(mosaic_2$mosaicfield_raster))
  )
  expect_equal(
    unname(terra::values(mosaic_3$steps[[3]])),
    unname(terra::values(mosaic_3$mosaicfield_raster))
  )
})

test_that("nlm_mosaicfield reproduces output with user_seed", {
  mosaic_a <- nlm_mosaicfield(ncol = 20, nrow = 20, n = 3, user_seed = 123)
  mosaic_b <- nlm_mosaicfield(ncol = 20, nrow = 20, n = 3, user_seed = 123)
  expect_equal(terra::values(mosaic_a), terra::values(mosaic_b))
})

# nolint end
