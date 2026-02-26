test_that("is_ppendemic returns one label per input", {
  species <- c("Aa aurantiaca", "Werneria nubigena", "Festuca densiflora")

  out <- is_ppendemic(species)

  expect_type(out, "character")
  expect_length(out, length(species))
  expect_equal(out, c("Endemic", "Not endemic", "Endemic"))
})

test_that("is_ppendemic handles typo correction pathway", {
  out <- is_ppendemic(c("Aa aurantiaaia"))

  expect_equal(out, "Endemic")
})

test_that("is_ppendemic works with tibble columns", {
  df <- tibble::tibble(splist = c("Aa aurantiaca", "Werneria nubigena"))

  res <- dplyr::mutate(df, endemic = is_ppendemic(splist))

  expect_equal(res$endemic, c("Endemic", "Not endemic"))
})

test_that("is_ppendemic forwards max_dist to matching engine", {
  strict <- is_ppendemic("Aa aurantiaaia", max_dist = 0)
  loose <- is_ppendemic("Aa aurantiaaia", max_dist = 2)

  expect_equal(strict, "Not endemic")
  expect_equal(loose, "Endemic")
})
