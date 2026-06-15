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

  A non-empty character vector containing taxon names. Missing and empty
  values are not accepted. Indeterminate `sp.` and `spp.` names are
  treated as genus-level records and are not classified as endemic taxa.

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

## Examples

``` r
# \donttest{
matching_ppendemic(c("Aa aurantiaca", "Aa aurantiaaia", "Werneria nubigena"))
#>   sorter         Orig.Name  Matched.Name Endemic.Tag Orig.Genus Orig.Species
#> 1      1     Aa aurantiaca Aa aurantiaca     Endemic         AA   AURANTIACA
#> 2      2    Aa aurantiaaia Aa aurantiaca     Endemic         AA  AURANTIAAIA
#> 3      3 Werneria nubigena      Werneria Not endemic   WERNERIA     NUBIGENA
#>   Orig.Infraspecies Rank Infra.Rank Comp.Rank Matched.Genus Matched.Species
#> 1              <NA>    2       <NA>      TRUE            AA      AURANTIACA
#> 2              <NA>    2       <NA>      TRUE            AA      AURANTIACA
#> 3              <NA>    2       <NA>     FALSE      WERNERIA            <NA>
#>   Matched.Infraspecies Matched.Rank matched direct_match genus_match
#> 1                 <NA>            2    TRUE         TRUE          NA
#> 2                 <NA>            2    TRUE        FALSE        TRUE
#> 3                 <NA>            1   FALSE        FALSE        TRUE
#>   fuzzy_match_genus direct_match_species_within_genus
#> 1                NA                                NA
#> 2                NA                             FALSE
#> 3                NA                             FALSE
#>   suffix_match_species_within_genus fuzzy_match_species_within_genus
#> 1                                NA                               NA
#> 2                             FALSE                             TRUE
#> 3                             FALSE                            FALSE
#>   fuzzy_genus_dist fuzzy_species_dist Author
#> 1               NA                 NA       
#> 2               NA                  2       
#> 3               NA                 NA       
# }
```
