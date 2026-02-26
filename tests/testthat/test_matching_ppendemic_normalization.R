test_that("name normalization tolerates case and underscore separators", {
  species <- c("aa_aurantiaca", "FESTUCA DENSIFLORA")

  out <- matching_ppendemic(species)

  expect_equal(out$Endemic.Tag, c("Endemic", "Endemic"))
})

test_that("hybrid mark is removed with warning", {
  expect_warning(
    out <- matching_ppendemic("Aa x aurantiaca"),
    "hybrids have been removed"
  )

  expect_equal(nrow(out), 1)
  expect_equal(out$Endemic.Tag, "Endemic")
})

test_that("output includes core columns required by downstream use", {
  out <- matching_ppendemic(c("Aa aurantiaca", "Werneria nubigena"))

  expected <- c(
    "sorter", "Orig.Name", "Matched.Name", "Endemic.Tag",
    "Orig.Genus", "Orig.Species", "Orig.Infraspecies", "Rank",
    "Matched.Genus", "Matched.Species", "Matched.Infraspecies",
    "Matched.Rank", "matched"
  )

  expect_true(all(expected %in% names(out)))
})
