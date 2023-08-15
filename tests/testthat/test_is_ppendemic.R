test_that("is_ppendemic correctly identifies endemic species", {
  # Test data
  species_list <- c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena")
  expected_result <- c("Endemic",
                       "Endemic - fuzzy matching",
                       "Not endemic")

  # Call the function
  result <- is_ppendemic(species_list, max_distance = 0.1)

  # Check the result
  expect_equal(result, expected_result)
})
