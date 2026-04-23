# # nolint start
# context("nlm_fBm")

# fbm_raster <- nlm_fbm(ncol = 9, nrow = 12, fract_dim = 0.5)

# test_that("nlm_fBm behaves like it should", {
#   expect_that(fbm_raster, is_a("RasterLayer"))
# })

# test_that("nlm_fBm produces the right number of rows", {
#   expect_equal(fbm_raster@nrows, 12)
# })

# test_that("nlm_fBm produces the right number of columns", {
#   expect_equal(fbm_raster@ncols, 9)
# })

# test_that("nlm_fBm is less correlated for small fract_dim", {
#   fbm_rough <- nlm_fbm(
#     ncol = 40,
#     nrow = 40,
#     fract_dim = 0.01,
#     user_seed = 1,
#     rescale = FALSE
#   )
#   fbm_smooth <- nlm_fbm(
#     ncol = 40,
#     nrow = 40,
#     fract_dim = 1.99,
#     user_seed = 1,
#     rescale = FALSE
#   )

#   lag1_cor <- function(x) {
#     m <- raster::as.matrix(x)
#     stats::cor(
#       c(m[-1, , drop = FALSE], m[, -1, drop = FALSE]),
#       c(m[-nrow(m), , drop = FALSE], m[, -ncol(m), drop = FALSE])
#     )
#   }

#   expect_lt(lag1_cor(fbm_rough), lag1_cor(fbm_smooth))
# })


# # test_that("nlm_fBm produces the right hurst coefficient", {
# #   h <- pracma::hurstexp(fbm_raster[], display = FALSE)
# #   expect_equal(h$Hal, 0.5, tolerance = 0.2)
# # })

# # nolint end
