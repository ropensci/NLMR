# nolint start
context("util_facetplot")

l1 <- nlm_random(32, 32)
l2 <- nlm_random(32, 32)
l3 <- nlm_random(16, 16)

bri1 <- raster::brick(l1, l2)
p1 <- util_facetplot(bri1)

lst1 <- list(lay1 = l1,
             lay2 = l2,
             lay3 = l3,
             lay4 = nlm_random(42, 42))
p2 <- util_facetplot(lst1)

test_that("basic functionality", {
  expect_error(util_facetplot(bri1), NA)
  expect_error(util_facetplot(lst1), NA)
})

test_that("util_plot behaves like it should", {
  expect_equal(class(p1), c("gg","ggplot"))
  expect_equal(class(p2), c("gg","ggplot"))
})

# nolint end
