# nolint start
context("util_plot")

x <- NLMR::nlm_random(ncol = 75,
                      nrow = 75)

p <- util_plot(x)

test_that("basic functionality", {
  expect_error(util_plot(x), NA)
})

test_that("util_plot behaves like it should", {
  expect_equal(class(p), c("gg","ggplot"))
})



# nolint end
