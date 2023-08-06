test_that("ppendemic_tab dataset is loaded correctly", {
  # Check if the dataset is available
  expect_true(exists("ppendemic_tab"))

  # Check the number of rows and columns
  expect_equal(nrow(ppendemic_tab), 7249)
  expect_equal(ncol(ppendemic_tab), 7)

  # Check column names
  expected_colnames <- c(
    "accepted_name", "accepted_family", "accepted_name_author",
    "publication_author", "place_of_publication", "volume_and_page", "first_published"
  )
  expect_equal(colnames(ppendemic_tab), expected_colnames)

  # Check if the dataset contains non-empty values
  expect_true(all(sapply(ppendemic_tab, function(x) any(!is.na(x)))))
})
