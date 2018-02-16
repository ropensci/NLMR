# nolint start
context("theme_nlm")

x <- NLMR::nlm_random(ncol = 75,
                      nrow = 75)

p1 <- rasterVis::gplot(x) +
  ggplot2::geom_tile(ggplot2::aes(fill = value)) +
  ggplot2::labs(x = "Easting",
                y = "Northing") +
  theme_nlm()

p2 <- rasterVis::gplot(x) +
  ggplot2::geom_tile(ggplot2::aes(fill = value)) +
  ggplot2::labs(x = "Easting",
                y = "Northing") +
  theme_nlm_discrete()

p3 <- rasterVis::gplot(x) +
  ggplot2::geom_tile(ggplot2::aes(fill = value)) +
  ggplot2::labs(x = "Easting",
                y = "Northing") +
  theme_nlm_grey()

p4 <- rasterVis::gplot(x) +
  ggplot2::geom_tile(ggplot2::aes(fill = value)) +
  ggplot2::labs(x = "Easting",
                y = "Northing") +
  theme_nlm_grey_discrete()

test_that("basic functionality", {
  expect_error(p1, NA)
  expect_error(p2, NA)
  expect_error(p3, NA)
  expect_error(p4, NA)
})

# nolint end
