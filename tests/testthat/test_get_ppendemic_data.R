
test_that("get_ppendemic_data retrieves correct data for valid species names", {
  # Sample input species list
  input_species <- c("Aa aurantiaca", "Aa aurantiaaia", "werneria nubigena")

  # Call the function to get the output
  output_data <- get_ppendemic_data(splist = input_species)
  output_data
  # Expected output data
  expected_data <- data.frame(
    name_submitted = c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"),
    accepted_name = c("Aa aurantiaca", "Aa aurantiaca", "nill"),
    accepted_family = c("Orchidaceae", "Orchidaceae", "nill"),
    accepted_name_author = c("D.Trujillo", "D.Trujillo", "nill"),
    publication_author = c(NA, NA, "nill"),
    place_of_publication = c("Lankesteriana", "Lankesteriana", "nill"),
    volume_and_page = c("11: 3", "11: 3", "nill"),
    first_published = c("(2011)", "(2011)", "nill"),
    dist = c(0, 2, "nill"),
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

  # Expected output is an empty data frame
  expected_data <- data.frame(
    name_submitted = c("Invalid species 1", "Invalid species 2", "Invalid species 3"),
    accepted_name = rep("nill", 3),
    accepted_family = rep("nill", 3),
    accepted_name_author = rep("nill", 3),
    publication_author = rep("nill", 3),
    place_of_publication = rep("nill", 3),
    volume_and_page = rep("nill", 3),
    first_published = rep("nill", 3),
    dist = rep("nill", 3),
    stringsAsFactors = FALSE
  )

  # Compare the output data with the expected data
  expect_equal(output_data, expected_data)
})
