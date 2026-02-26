# Match Species Names to Endemic Plant List of Peru

This function matches given species names against the internal database
of endemic plant species in Peru.

## Usage

``` r
matching_ppendemic(
  splist,
  max_dist = 2,
  save_ambiguous = FALSE,
  ambiguous_path = "ambiguous_genera.csv"
)
```

## Arguments

- splist:

  A vector containing the species list.

- max_dist:

  Maximum edit distance used in fuzzy matching steps. Defaults to 2 (the
  default in fuzzyjoin::stringdist_left_join()).

- save_ambiguous:

  Logical flag. If `TRUE`, ambiguous fuzzy genus matches are exported to
  disk.

- ambiguous_path:

  File path used when `save_ambiguous = TRUE`. Defaults to
  `"ambiguous_genera.csv"`.

## Value

Returns a tibble with the matched names in Matched.Genus,
Matched.Species for binomial names, and Matched.Infraspecies for valid
infra species names.

## Details

The function first attempts to directly match species names with exact
matches in the database (genus and specific epithet, or genus, specific
epithet, and infra species). If no exact match is found, the function
performs a fuzzy match using the fuzzyjoin package with optimal string
alignment distance as implemented in stringdist.

The maximum edit distance can be controlled through `max_dist`.

The function matching_ppendemic returns a tibble with new columns
Matched.Genus, Matched.Species, and Matched.Infraspecies, containing the
matched names or NA if no match was found.

Additionally, a logical column is added for each function called,
allowing users to see which functions were applied to each name during
the matching process. If a process column shows `NA`, the corresponding
function was not called for that name because it was already matched by
a preceding function.
