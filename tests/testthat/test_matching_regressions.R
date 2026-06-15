test_that("infraspecific rank is part of the exact match key", {
  species <- c(
    "Dasyphyllum brasiliense var. barnadesioides",
    "Dasyphyllum brasiliense subsp. barnadesioides",
    "Dasyphyllum brasiliense f. barnadesioides"
  )

  out <- matching_ppendemic(species, max_dist = 0)

  expect_equal(
    out$Endemic.Tag,
    c("Endemic", "Not endemic", "Not endemic")
  )
})

test_that("infraspecific matching stays within genus species and rank", {
  nonexistent <- c(
    "Aa aurantiaca subsp. fruticosa",
    "Miconia alpina subsp. alpina",
    "Acaulimalva acaulis var. magna"
  )

  out <- matching_ppendemic(nonexistent, max_dist = 0)

  expect_true(all(out$Endemic.Tag == "Not endemic"))
})

test_that("fuzzy matching preserves duplicated input rows", {
  species <- c(
    "Aa aurantiaaia",
    "Aa aurantiaaia",
    "Dasyphyllum brasiliense var. barnadesioide",
    "Dasyphyllum brasiliense var. barnadesioide"
  )

  out <- matching_ppendemic(species)

  expect_equal(nrow(out), length(species))
  expect_equal(out$sorter, seq_along(species))
  expect_true(all(out$Endemic.Tag == "Endemic"))
})
