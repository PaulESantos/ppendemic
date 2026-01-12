# Suffix Match Species within Genus

Function to match the specific epithet by exchanging common suffixes
within an already matched genus in the ppendemic database.

## Usage

``` r
suffix_match_species_within_genus_helper(df, target_df)
```

## Arguments

- df:

  A tibble.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

Returns a tibble with the additional logical column
suffix_match_species_within_genus, indicating whether the specific
epithet was successfully matched within the matched genus (`TRUE`) or
not (`FALSE`).
