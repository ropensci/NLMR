context("catalog_nlm")

test_that("catalog_nlm returns a tibble with expected columns", {
  out <- catalog_nlm()

  expect_s3_class(out, "tbl_df")
  expect_named(out, c("algorithm", "group", "description", "variants", "reference"))
  expect_equal(nrow(out), 15)
})

test_that("catalog_nlm returns results ordered for browsing", {
  out <- catalog_nlm()

  expect_equal(out, out[order(out$group, out$algorithm), , drop = FALSE])
})

test_that("catalog_nlm descriptions are non-empty and specific", {
  out <- catalog_nlm()

  expect_true(all(nzchar(out$description)))
  expect_true(any(grepl("random", out$description, ignore.case = TRUE)))
  expect_true(any(grepl("gradient", out$description, ignore.case = TRUE)))
  expect_true(any(grepl("tessellation|cluster|fractal", out$description, ignore.case = TRUE)))
})

test_that("catalog_nlm counts curds as two variants", {
  out <- catalog_nlm()

  expect_equal(sum(out$variants), 16L)
  expect_equal(out$variants[out$algorithm == "nlm_curds"], 2L)
})
