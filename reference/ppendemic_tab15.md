# ppendemic_tab15: Endemic Plant Database of Peru (based on WCVP v15)

The `ppendemic_tab15` dataset is a tibble (data frame) providing a
curated and taxonomically validated list of vascular plant taxa that
occur exclusively in Peru. The dataset is derived from version 15 of the
World Checklist of Vascular Plants (WCVP), facilitated by the Royal
Botanic Gardens, Kew, and corresponds to the extraction performed on 06
January 2026.

## Usage

``` r
ppendemic_tab15
```

## Format

A tibble (data frame) with 7,892 rows and 18 columns:

- taxon_name:

  Character vector. The full scientific name of the accepted endemic
  taxon, constructed from genus, species and, where applicable,
  infraspecific epithets, following WCVP standards.

- taxon_status:

  Character vector. The taxonomic status of the name according to WCVP
  (e.g., `"Accepted"`).

- family:

  Character vector. The botanical family to which the endemic taxon
  belongs, following WCVP family circumscription.

- Genus:

  Character vector. The genus name of the endemic taxon.

- Species:

  Character vector. The specific epithet of the endemic taxon.

- infraspecific_rank:

  Character vector. The infraspecific rank (e.g., `"subsp."`, `"var."`)
  when applicable.

- infraspecies:

  Character vector. The infraspecific epithet when applicable.

- taxon_authors:

  Character vector. The standardized authorship of the taxon name,
  concatenating parenthetical and primary authors following botanical
  nomenclature conventions.

- primary_author:

  Character vector. The author(s) who validly published the scientific
  name.

- place_of_publication:

  Character vector. The journal, book or other publication in which the
  taxon name was effectively published.

- volume_and_page:

  Character vector. The volume and page reference of the original
  publication of the taxon name (e.g., `"13(2): 99"`).

- first_published:

  Character vector. The year of publication of the name, enclosed in
  parentheses, as reported by WCVP.

- year_actual:

  Numeric vector. The actual year of publication extracted from
  `first_published`.

- year_nominal:

  Numeric vector. The nominal year of publication extracted from
  `first_published`.

- both_years:

  Character vector. A concatenation of actual and nominal years when
  these differ (format `"YYYY|YYYY"`).

- has_different_years:

  Logical vector. Indicates whether the actual and nominal publication
  years differ.

- version:

  Character vector. The database version identifier `"V-15"`,
  corresponding to WCVP version 15.

- version_date:

  Character vector. The extraction date of the WCVP source dataset
  (`"06-01-2026"`).

## Source

Data derived from:

Govaerts, R. (ed.). 2026. WCVP: World Checklist of Vascular Plants.
Facilitated by the Royal Botanic Gardens, Kew. Version 15. Extracted 06
January 2026. https://doi.org/10.34885/rvc3-4d77

For methodological details:

Govaerts, R., Nic Lughadha, E., et al. (2021). The World Checklist of
Vascular Plants, a continuously updated resource for exploring global
plant diversity. Scientific Data, 8, 215.
https://doi.org/10.1038/s41597-021-00997-6

## Details

This database contains only accepted endemic taxon names, following the
taxonomic backbone of WCVP and filtered by geographic distribution
records indicating occurrence restricted to Peru.

The dataset was constructed from the World Checklist of Vascular Plants
(WCVP) version 15, a continuously updated global taxonomic resource
curated by the Royal Botanic Gardens, Kew. Only taxa of rank species and
below with accepted status were considered.

Geographic distribution fields from WCVP were used to identify taxa
whose native range is restricted exclusively to Peru. Introduced,
cultivated, misapplied, synonymic and unplaced names were excluded.

The nomenclature, authorship, family assignment and publication details
strictly follow the International Code of Nomenclature for algae, fungi
and plants (ICN) and WCVP editorial standards.

Temporal metadata was processed to extract both nominal and actual
publication years, allowing detailed historical bibliographic analysis
of Peruvian endemic flora.

## References

Royal Botanic Gardens, Kew (2026). World Checklist of Vascular Plants
(WCVP), Version 15. https://wcvp.science.kew.org
