test_that("matching_ppendemic preserves row count and input order", {
  species <- c("Aa aurantiaca", "Werneria nubigena", "Festuca densiflora")

  out <- matching_ppendemic(species)

  expect_equal(nrow(out), length(species))
  expect_equal(out$Orig.Name, species)
  expect_equal(out$sorter, seq_along(species))
})

test_that("matching_ppendemic resolves exact, fuzzy and non-endemic examples", {
  species <- c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena")

  out <- matching_ppendemic(species)

  expect_equal(out$Endemic.Tag, c("Endemic", "Endemic", "Not endemic"))
  expect_true(out$matched[1])
  expect_true(out$matched[2])
  expect_false(out$matched[3])
})

test_that("matching_ppendemic detects infraspecies from README example", {
  species <- "Dasyphyllum brasiliense var. barnadesioides"

  out <- matching_ppendemic(species)

  expect_equal(nrow(out), 1)
  expect_equal(out$Rank, 3)
  expect_equal(out$Endemic.Tag, "Endemic")
  expect_equal(out$Matched.Rank, 3)
})

test_that("matching_ppendemic reports genus-only input and marks as not endemic", {
  expect_message(
    out <- matching_ppendemic("Festuca"),
    "genus level"
  )

  expect_equal(nrow(out), 1)
  expect_equal(out$Rank, 1)
  expect_equal(out$Endemic.Tag, "Not endemic")
})

test_that("matching_ppendemic handles genus-only and mixed-rank inputs without crashing", {
  expect_message(
    out_single <- matching_ppendemic("Festuca"),
    "genus level"
  )

  expect_equal(nrow(out_single), 1)
  expect_equal(out_single$Endemic.Tag, "Not endemic")

  expect_message(
    out_mixed <- matching_ppendemic(c("Festuca", "Aa aurantiaca")),
    "genus level"
  )

  expect_equal(nrow(out_mixed), 2)
  expect_equal(out_mixed$Orig.Name, c("Festuca", "Aa aurantiaca"))
  expect_equal(out_mixed$sorter, c(1, 2))
  expect_equal(out_mixed$Endemic.Tag, c("Not endemic", "Endemic"))
})

test_that("matching_ppendemic exposes max_dist control for fuzzy matching", {
  strict <- matching_ppendemic("Aa aurantiaaia", max_dist = 0)
  default <- matching_ppendemic("Aa aurantiaaia")
  loose <- matching_ppendemic("Aa aurantiaaia", max_dist = 2)

  expect_equal(strict$Endemic.Tag, "Not endemic")
  expect_equal(default$Endemic.Tag, "Endemic")
  expect_equal(loose$Endemic.Tag, "Endemic")
})
