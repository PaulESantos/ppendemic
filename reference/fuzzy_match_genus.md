# Fuzzy Match Genus Name

This function performs a fuzzy match of genus names against the
ppendemic database using fuzzyjoin::stringdist() to account for slight
variations in spelling.

## Usage

``` r
fuzzy_match_genus(df, target_df = NULL)
```

## Arguments

- df:

  A tibble containing the genus names to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

A tibble with two additional columns:

- fuzzy_match_genus: A logical column indicating whether the genus was
  successfully matched (`TRUE`) or not (`FALSE`).

- fuzzy_genus_dist: A numeric column representing the distance for each
  match.
