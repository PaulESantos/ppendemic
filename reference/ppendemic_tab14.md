# ppendemic_tab14: Endemic Plant Database of Peru

The ppendemic_tab14 dataset is a tibble (data frame) that provides easy
access to a comprehensive database of Peru's accepted endemic plant
taxa. It contains 7,898 taxonomic records at species and infraspecific
ranks, with information including the accepted name, family, genus,
specific epithet, taxon authors, primary author, place of publication,
volume and page, publication years, and version details.

## Usage

``` r
ppendemic_tab14
```

## Format

A tibble (data frame) with 7,898 rows and 18 columns:

- taxon_name:

  Character vector. The accepted name of the endemic plant taxon.

- taxon_status:

  Character vector. The taxonomic status of the name (e.g., "Accepted").

- family:

  Character vector. The family of the accepted name of the endemic plant
  taxon.

- Genus:

  Character vector. The genus of the endemic plant taxon.

- Species:

  Character vector. The specific epithet of the endemic plant taxon.

- infraspecific_rank:

  Character vector. The infraspecific rank (e.g., "subsp.", "var.") when
  applicable.

- infraspecies:

  Character vector. The infraspecific epithet when applicable.

- taxon_authors:

  Character vector. The author(s) of the accepted name of the endemic
  plant taxon.

- primary_author:

  Character vector. The primary author(s) of the publication containing
  the endemic plant taxon information.

- place_of_publication:

  Character vector. The place of publication of the endemic plant taxon
  information.

- volume_and_page:

  Character vector. The volume and page number of the publication
  containing the endemic plant taxon information.

- first_published:

  Character vector. The first published year of the publication
  containing the endemic plant taxon information.

- year_actual:

  Numeric vector. The actual year of publication extracted from
  first_published.

- year_nominal:

  Numeric vector. The nominal year of publication extracted from
  first_published.

- both_years:

  Character vector. Both actual and nominal years when different,
  extracted from first_published.

- has_different_years:

  Logical vector. Indicates whether the actual and nominal publication
  years differ (TRUE when both_years contains the pattern "YYYY\|YYYY").

- version:

  Character vector. The version identifier "V-14" of the ppendemic
  database.

- version_date:

  Character vector. The version date "28-05-2025" indicating when this
  version was created.

## Source

The dataset has been carefully compiled and updated to offer the latest
insights into Peru's endemic plant taxa. The data is sourced from the
World Checklist of Vascular Plants (WCVP) database, an international
collaborative programme initiated in 1988 by Rafaël Govaerts that
provides high-quality expert-reviewed taxonomic data on all vascular
plants.

For detailed methodology, see Govaerts et al. (2021) "The World
Checklist of Vascular Plants, a continuously updated resource for
exploring global plant diversity" in Nature Scientific Data.

## Details

The dataset provides a curated collection of Peru's accepted endemic
plant taxa, gathered from reputable botanical sources and publications.
The data for this database was extracted and compiled from the World
Checklist of Vascular Plants (WCVP) database, which is a comprehensive
and reliable repository of botanical information.

This version (ppendemic_tab14) includes enhanced temporal information
with separate numeric fields for actual and nominal publication years.
This allows for more precise bibliographic tracking and citation
accuracy. The dataset also includes improved infraspecific taxonomy
handling with dedicated fields for ranks and epithets.

The year extraction process uses sophisticated pattern matching to
distinguish between actual publication years and nominal years, with the
has_different_years field automatically flagging records where these
differ. This is particularly important for historical botanical
publications where publication delays were common.

## Examples

``` r

# Load the package
library(ppendemic)

# Access the dataset
data("ppendemic_tab14")

# View the structure of the dataset
str(ppendemic_tab14)
#> tibble [7,898 × 18] (S3: tbl_df/tbl/data.frame)
#>  $ taxon_name          : chr [1:7898] "Pappobolus verbesinoides" "Maxillaria briggittheae" "Pappobolus lanatus" "Maxillaria beckendorfii" ...
#>  $ taxon_status        : chr [1:7898] "Accepted" "Accepted" "Accepted" "Accepted" ...
#>  $ family              : chr [1:7898] "Asteraceae" "Orchidaceae" "Asteraceae" "Orchidaceae" ...
#>  $ Genus               : chr [1:7898] "Pappobolus" "Maxillaria" "Pappobolus" "Maxillaria" ...
#>  $ Species             : chr [1:7898] "verbesinoides" "briggittheae" "lanatus" "beckendorfii" ...
#>  $ infraspecific_rank  : chr [1:7898] NA NA NA NA ...
#>  $ infraspecies        : chr [1:7898] NA NA NA NA ...
#>  $ taxon_authors       : chr [1:7898] "(Kunth) Panero" "Molinari" "(Heiser) Panero" "(Carnevali) Molinari" ...
#>  $ primary_author      : chr [1:7898] "Panero" "Molinari" "Panero" "Molinari" ...
#>  $ place_of_publication: chr [1:7898] "Syst. Bot. Monogr." "Richardiana" "Syst. Bot. Monogr." "Richardiana" ...
#>  $ volume_and_page     : chr [1:7898] " 36: 75" " 15: 302" " 36: 164" " 15: 294" ...
#>  $ first_published     : chr [1:7898] "(1992)" "(2015)" "(1992)" "(2015)" ...
#>  $ year_actual         : num [1:7898] 1992 2015 1992 2015 2002 ...
#>  $ year_nominal        : num [1:7898] 1992 2015 1992 2015 2002 ...
#>  $ both_years          : chr [1:7898] "1992" "2015" "1992" "2015" ...
#>  $ has_different_years : logi [1:7898] FALSE FALSE FALSE FALSE FALSE NA ...
#>  $ version             : chr [1:7898] "V-14" "V-14" "V-14" "V-14" ...
#>  $ version_date        : chr [1:7898] "28-05-2025" "28-05-2025" "28-05-2025" "28-05-2025" ...

# View first few rows
head(ppendemic_tab14)
#> # A tibble: 6 × 18
#>   taxon_name   taxon_status family Genus Species infraspecific_rank infraspecies
#>   <chr>        <chr>        <chr>  <chr> <chr>   <chr>              <chr>       
#> 1 Pappobolus … Accepted     Aster… Papp… verbes… NA                 NA          
#> 2 Maxillaria … Accepted     Orchi… Maxi… briggi… NA                 NA          
#> 3 Pappobolus … Accepted     Aster… Papp… lanatus NA                 NA          
#> 4 Maxillaria … Accepted     Orchi… Maxi… becken… NA                 NA          
#> 5 Oreocereus … Accepted     Cacta… Oreo… doelzi… subsp.             calvus      
#> 6 Hyptis salv… Accepted     Lamia… Hypt… salvio… NA                 NA          
#> # ℹ 11 more variables: taxon_authors <chr>, primary_author <chr>,
#> #   place_of_publication <chr>, volume_and_page <chr>, first_published <chr>,
#> #   year_actual <dbl>, year_nominal <dbl>, both_years <chr>,
#> #   has_different_years <lgl>, version <chr>, version_date <chr>

# Check for taxa with different actual and nominal years
different_years <- subset(ppendemic_tab14, has_different_years == TRUE)
nrow(different_years)
#> [1] 160

# View records with both years information
head(ppendemic_tab14$both_years[ppendemic_tab14$has_different_years])
#> [1] NA          "1997|1998" "2001|2002" "2002|2003" "1938|1937" "2013|2014"

```
