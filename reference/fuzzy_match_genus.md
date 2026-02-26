# Fuzzy Match Genus Name

This function performs a fuzzy match of genus names against the
ppendemic database using fuzzyjoin::stringdist() to account for slight
variations in spelling.

## Usage

``` r
fuzzy_match_genus(
  df,
  target_df = NULL,
  max_dist = 2,
  save_ambiguous = FALSE,
  ambiguous_path = "ambiguous_genera.csv"
)
```

## Arguments

- df:

  A tibble containing the genus names to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

- max_dist:

  Maximum edit distance used by fuzzyjoin::stringdist\_\* joins.

- save_ambiguous:

  Logical flag. If `TRUE`, ambiguous fuzzy genus matches are exported to
  disk.

- ambiguous_path:

  File path used when `save_ambiguous = TRUE`. Defaults to
  `"ambiguous_genera.csv"`.

## Value

A tibble with two additional columns:

- fuzzy_match_genus: A logical column indicating whether the genus was
  successfully matched (`TRUE`) or not (`FALSE`).

- fuzzy_genus_dist: A numeric column representing the distance for each
  match.
