# Direct Match

This function performs a direct match of species names. It matches the
genus and species if the name is binomial, and matches the genus,
species, and infra species if the name includes a subspecies.

## Usage

``` r
direct_match(df, target_df = NULL)
```

## Arguments

- df:

  A tibble containing the species data to be matched.

- target_df:

  A tibble representing the ppendemic database containing the reference
  list of endemic species.

## Value

A tibble with an additional logical column direct_match indicating
whether the binomial or trinomial name was successfully matched (`TRUE`)
or not (`FALSE`).
