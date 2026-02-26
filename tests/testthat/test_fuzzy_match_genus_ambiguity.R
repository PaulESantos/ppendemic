test_that("fuzzy_match_genus resolves ambiguous ties deterministically", {
  df <- tibble::tibble(
    Orig.Name = "Aab test",
    Orig.Genus = "AAB",
    Orig.Species = "TEST",
    Orig.Infraspecies = NA_character_
  )

  target_df <- tibble::tibble(
    Genus = c("AAA", "AAC"),
    Species = c("S1", "S2"),
    infraspecies = c(NA_character_, NA_character_)
  )

  expect_warning(
    out <- ppendemic:::fuzzy_match_genus(df, target_df = target_df, max_dist = 1),
    "Multiple fuzzy genus matches"
  )

  expect_equal(nrow(out), 1)
  expect_true(out$fuzzy_match_genus)
  expect_equal(out$Matched.Genus, "AAA")
})

test_that("fuzzy_match_genus writes ambiguous report only when requested", {
  df <- tibble::tibble(
    Orig.Name = "Aab test",
    Orig.Genus = "AAB",
    Orig.Species = "TEST",
    Orig.Infraspecies = NA_character_
  )

  target_df <- tibble::tibble(
    Genus = c("AAA", "AAC"),
    Species = c("S1", "S2"),
    infraspecies = c(NA_character_, NA_character_)
  )

  out_path <- tempfile(fileext = ".csv")

  expect_warning(
    ppendemic:::fuzzy_match_genus(df,
                                  target_df = target_df,
                                  max_dist = 1,
                                  save_ambiguous = FALSE,
                                  ambiguous_path = out_path),
    "Multiple fuzzy genus matches"
  )
  expect_false(file.exists(out_path))

  expect_warning(
    ppendemic:::fuzzy_match_genus(df,
                                  target_df = target_df,
                                  max_dist = 1,
                                  save_ambiguous = TRUE,
                                  ambiguous_path = out_path),
    "Multiple fuzzy genus matches"
  )
  expect_true(file.exists(out_path))

  exported <- readr::read_csv(out_path, show_col_types = FALSE)
  expect_true(all(c("Orig.Genus", "Orig.Species", "Matched.Genus",
                    "fuzzy_genus_dist") %in% names(exported)))
})
