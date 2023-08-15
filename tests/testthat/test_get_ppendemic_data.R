
test_that("get_ppendemic_data retrieves correct data for valid species names", {
  # Sample input species list
  input_species <- c("Aa aurantiaca", "Aa aurantiaaia", "werneria nubigena")

  # Call the function to get the output
  output_data <- get_ppendemic_data(splist = input_species)
  #output_data
  # Expected output data
  expected_data <- data.frame(
    name_submitted = c("Aa aurantiaca", "Aa aurantiaaia"),
    accepted_name = c("Aa aurantiaca", "Aa aurantiaca"),
    accepted_family = c("Orchidaceae", "Orchidaceae"),
    accepted_name_author = c("D.Trujillo", "D.Trujillo"),
    publication_author = c("nill", "nill"),
    place_of_publication = c("Lankesteriana", "Lankesteriana"),
    volume_and_page = c("11: 3", "11: 3"),
    first_published = c("(2011)", "(2011)"),
    dist = c("0", "2"),
    stringsAsFactors = FALSE
  )
  # Compare the output data with the expected data
  expect_equal(output_data, expected_data)
})

test_that("get_ppendemic_data returns empty data frame for invalid species names", {
  # Sample input species list with invalid names
  invalid_species <- c("Invalid species 1", "Invalid species 2", "Invalid species 3")

  # Call the function to get the output
  output_data <- get_ppendemic_data(splist = invalid_species)
  #output_data |>  ncol()
  # Expected output is an empty data frame
  expected_row <- 0
  expected_col <- 9
  # Compare the output data with the expected data
  expect_equal(nrow(output_data), expected_row)
  expect_equal(ncol(output_data), expected_col)
})
