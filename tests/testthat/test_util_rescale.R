test_that("util_rescale rescales each layer independently", {
  x <- terra::rast(nrows = 2, ncols = 2, nlyrs = 4)
  terra::values(x) <- cbind(
    first = c(1, 2, 3, 4),
    second = c(10, 20, 30, 40),
    constant = c(5, NA, 5, NA),
    missing = rep(NA_real_, 4)
  )

  result <- NLMR:::util_rescale(x)

  expect_equal(
    unname(terra::values(result[[1]])),
    matrix(c(0, 1 / 3, 2 / 3, 1), ncol = 1)
  )
  expect_equal(
    unname(terra::values(result[[2]])),
    matrix(c(0, 1 / 3, 2 / 3, 1), ncol = 1)
  )
  expect_equal(
    unname(terra::values(result[[3]])),
    matrix(c(0, NA, 0, NA), ncol = 1)
  )
  expect_true(all(is.na(terra::values(result[[4]]))))
  expect_equal(names(result), names(x))
  expect_equal(terra::ext(result), terra::ext(x))
  expect_equal(terra::res(result), terra::res(x))
})
