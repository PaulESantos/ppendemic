test_that("all species within genus names matched in test", {
  species <- c('Festuca densiflora',
               'Festuca dentiflora')
  df <- matching_ppendemic(species)

  expect_true(all(as.logical(df$matched)))
  expect_true(all(df$Matched.Name %in% df$Orig.Name))

})
