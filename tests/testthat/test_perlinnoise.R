context("nlm_perlinnoise")

test_that("nlm_perlinnoise returns the requested raster", {
  out <- nlm_perlinnoise(ncol = 12, nrow = 10, resolution = 2,
                         periods = 3, user_seed = 678)

  expect_s4_class(out, "SpatRaster")
  expect_equal(terra::ncol(out), 12)
  expect_equal(terra::nrow(out), 10)
  expect_equal(terra::res(out), c(2, 2))
  expect_gte(min(terra::values(out)), 0)
  expect_lte(max(terra::values(out)), 1)
})

test_that("nlm_perlinnoise is reproducible with user_seed", {
  a <- nlm_perlinnoise(20, 20, user_seed = 678)
  b <- nlm_perlinnoise(20, 20, user_seed = 678)
  expect_equal(terra::values(a), terra::values(b))
})

test_that("nlm_perlinnoise validates parameters", {
  expect_error(nlm_perlinnoise(10, 10, periods = 0), "periods")
  expect_error(nlm_perlinnoise(10, 10, octaves = 0), "octaves")
  expect_error(nlm_perlinnoise(10, 10, lacunarity = 0.5), "lacunarity")
  expect_error(nlm_perlinnoise(10, 10, persistence = 1.1), "persistence")
})

test_that("nlm_perlinnoise follows the paper's row-column period convention", {
  out <- nlm_perlinnoise(40, 40, periods = c(5, 1), octaves = 1, user_seed = 678)
  values <- matrix(terra::values(out), nrow = terra::nrow(out), ncol = terra::ncol(out), byrow = TRUE)
  row_variation <- mean(abs(values[-1, ] - values[-nrow(values), ]))
  col_variation <- mean(abs(values[, -1] - values[, -ncol(values)]))
  expect_gt(row_variation, col_variation)
})

test_that("nlm_perlinnoise can return unscaled values", {
  out <- nlm_perlinnoise(16, 16, rescale = FALSE, user_seed = 678)
  expect_true(min(terra::values(out)) < 0)
  expect_true(max(terra::values(out)) > 0)
})
