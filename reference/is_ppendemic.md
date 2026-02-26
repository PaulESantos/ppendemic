# Check if species are endemic in the ppendemic database

This function checks if a list of species names are endemic in the
ppendemic database. The function allows fuzzy matching for species names
with a maximum distance threshold to handle potential typos or
variations in species names.

## Usage

``` r
is_ppendemic(
  splist,
  max_dist = 2,
  save_ambiguous = FALSE,
  ambiguous_path = "ambiguous_genera.csv"
)
```

## Arguments

- splist:

  A character vector containing the list of species names to be checked
  for endemic in the ppendemic database.

- max_dist:

  Maximum edit distance used in fuzzy matching steps. Defaults to 2.

- save_ambiguous:

  Logical flag. If `TRUE`, ambiguous fuzzy genus matches are exported to
  disk.

- ambiguous_path:

  File path used when `save_ambiguous = TRUE`. Defaults to
  `"ambiguous_genera.csv"`.

## Value

A character vector indicating if each species is endemic or not endemic.

## Examples

``` r
# \donttest{
is_ppendemic(c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"))
#> [1] "Endemic"     "Endemic"     "Not endemic"
# }
```
