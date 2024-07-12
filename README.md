
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ppendemic <a href='https://github.com/PaulESantos/ppendemic'><img src='man/figures/ppendemic_logo.png' align="right" height="250" width="220" /></a>

<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/ppendemic)](https://CRAN.R-project.org/package=ppendemic)
[![](http://cranlogs.r-pkg.org/badges/grand-total/ppendemic?color=green)](https://cran.r-project.org/package=ppendemic)
[![](http://cranlogs.r-pkg.org/badges/last-week/ppendemic?color=green)](https://cran.r-project.org/package=ppendemic)
[![Codecov test
coverage](https://codecov.io/gh/PaulESantos/ppendemic/branch/main/graph/badge.svg)](https://app.codecov.io/gh/PaulESantos/ppendemic?branch=main)
[![DOI](https://zenodo.org/badge/336340798.svg)](https://zenodo.org/badge/latestdoi/336340798)
[![R-CMD-check](https://github.com/PaulESantos/ppendemic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PaulESantos/ppendemic/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Overview

This package offers convenient access to a new and extensive database
containing a list of 7,249 endemic plant species found in Peru. This
comprehensive collection provides detailed botanical information,
including accepted names, family, authorship, publication details, and
the place and date of first publication for each species.

The construction of the ppendemic package is built upon valuable data
sourced from the renowned `World Checklist of Vascular Plants (WCVP)`
database. As a highly authoritative resource, WCVP offers comprehensive
information on plant taxonomy and occurrence worldwide. Leveraging this
data, the `ppendemic` package aims to present an up-to-date and novel
compilation of Peru’s endemic plant species, tailored to the diverse
ecosystems of the region. By incorporating meticulously curated data
from WCVP, this package offers users a reliable and accurate resource to
explore, analyze, and gain deeper insights into the rich diversity of
Peru’s endemic flora.

Representing a significant advancement in our understanding of Peru’s
endemic plant species, the `ppendemic` package surpasses the previously
known list of 5,507 species presented in the Red Book of Endemic Plants
of Peru, bringing the total to an impressive 7,249 species. This
substantial increase in documented endemic species is a testament to the
integration of data and the commitment to presenting the most up-to-date
information. With this expanded and current database, researchers,
conservationists, and nature enthusiasts alike can now delve into a more
comprehensive and accurate account of Peru’s unique and diverse plant
biodiversity. The `ppendemic` package stands as a valuable resource for
anyone interested in the study, conservation, and appreciation of Peru’s
endemic plant life.

The database spans a total of 169 families, with particular richness
observed in the **Orchidaceae, Asteraceae, Piperaceae, Solanaceae,
Fabaceae, Bromeliaceae, Melastomataceae, Araceae, Rubiaceae, and
Gentianaceae** families, all of which boast the highest number of
endemic species in Peru.

<img src="man/figures/README-unnamed-chunk-2-1.png" width="100%" />

## Installation

You can install the `ppendemic` package from CRAN using:

``` r
install.packages("ppendemic")
# or
pak::pak("ppendemic")
```

Also you can install the `ppendemic` package from GitHub using the
following command:

``` r
pak::pak("PaulESantos/ppendemic")
```

## Getting Started

After installing the `ppendemic` package, you can load it into your R
session using:

``` r
library(ppendemic)
```

- Use `is_ppendemic()` to check if taxa are endemic

``` r
splist <- c("Aa aurantiaca", 
             "Aa aurantiaaia",
             "Werneria nubigena", 
             "Dasyphyllum brasiliense var. barnadesioides",
             "Miconia firma",
             "Festuca densiflora")
is_ppendemic(splist)
#> [1] "endemic"     "endemic"     "not endemic" "endemic"     "endemic"    
#> [6] "endemic"
```

- The `is_ppendemic()` function is designed to work seamlessly with
  tibbles, allowing users to easily analyze and determine the endemism
  status of species within a tabular format.

``` r

tibble::tibble(splist = splist) |> 
  dplyr::mutate(endemic = is_ppendemic(splist))
#> # A tibble: 6 × 2
#>   splist                                      endemic    
#>   <chr>                                       <chr>      
#> 1 Aa aurantiaca                               endemic    
#> 2 Aa aurantiaaia                              endemic    
#> 3 Werneria nubigena                           not endemic
#> 4 Dasyphyllum brasiliense var. barnadesioides endemic    
#> 5 Miconia firma                               endemic    
#> 6 Festuca densiflora                          endemic
```

## Citation

To cite the `ppendemic` package, please use:

``` r
citation("ppendemic")
#> To cite ppendemic in publications use:
#> 
#>   Santos-Andrade PE, Vilca-Bustamante LL (2023). ppendemic: A glimpse
#>   at the diversity of Peru's endemic plants.
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     author = {Paul E. Santos Andrade and Lucely L. Vilca Bustamante},
#>     title = {ppendemic: A glimpse at the diversity of Peru's endemic plants},
#>     year = {2024},
#>     doi = {10.5281/zenodo.5106619},
#>     url = {https://paulesantos.github.io/ppendemic/},
#>   }
```
