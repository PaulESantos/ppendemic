# Match Genus Name

This function performs a direct match of genus names against the genus
names listed in the ppendemic database.

## Usage

``` r
genus_match(df, target_df = NULL)
```

## Arguments

- df:

  A tibble containing the genus names to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

A tibble with an additional logical column genus_match indicating
whether the genus was successfully matched (`TRUE`) or not (`FALSE`).
