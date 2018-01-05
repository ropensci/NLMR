# nolint start
context("theme_nlm")

x <- NLMR::nlm_random(ncol = 75,
                      nrow = 75)

p <- rasterVis::gplot(x) +
 ggplot2::geom_tile(ggplot2::aes(fill = value)) +
 ggplot2::labs(x = "Easting",
               y = "Northing") +
 theme_nlm()

test_that("basic functionality", {
  expect_error(p, NA)
})


test_that("sets the right font", {
  th <- theme_nlm()
  expect_that(th[[1]]$plot.title$family, equals("Roboto Condensed"))
})


# nolint end
