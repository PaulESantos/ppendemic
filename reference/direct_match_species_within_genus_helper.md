# Direct Match Species within Genus

This function performs a direct match of specific epithets within an
already matched genus from the list of endemic species in the ppendemic
database.

## Usage

``` r
direct_match_species_within_genus_helper(df, target_df)
```

## Arguments

- df:

  A tibble containing the species data to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

A tibble with an additional logical column indicating whether the
specific epithet was successfully matched within the matched genus
(`TRUE`) or not (`FALSE`).
