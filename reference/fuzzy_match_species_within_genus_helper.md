# Fuzzy Match Species within Genus

This function attempts to fuzzy match species names within a genus to
the ppendemic database using fuzzyjoin::stringdist for fuzzy matching.

## Usage

``` r
fuzzy_match_species_within_genus_helper(df, target_df, max_dist)
```

## Arguments

- df:

  A tibble containing the species data to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

- max_dist:

  Maximum edit distance used by fuzzyjoin::stringdist\_\* joins.

## Value

A tibble with an additional logical column
fuzzy_match_species_within_genus, indicating whether the specific
epithet was successfully fuzzy matched within the matched genus (`TRUE`)
or not (`FALSE`).
