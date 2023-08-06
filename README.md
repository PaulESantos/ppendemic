
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ppendemic

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![CRAN
status](https://www.r-pkg.org/badges/version/ppendemic)](https://CRAN.R-project.org/package=ppendemic)
[![](http://cranlogs.r-pkg.org/badges/grand-total/ppendemic?color=green)](https://cran.r-project.org/package=ppendemic)
[![](http://cranlogs.r-pkg.org/badges/last-week/ppendemic?color=green)](https://cran.r-project.org/package=ppendemic)

[![R-CMD-check](https://github.com/PaulESantos/ppendemic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PaulESantos/ppendemic/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/PaulESantos/ppendemic/branch/main/graph/badge.svg)](https://app.codecov.io/gh/PaulESantos/ppendemic?branch=main)
<!-- badges: end -->

## Overview

`ppendemic` is an R package that provides easy access to a new database
containing the list of endemic plant species found in Peru. The package
includes a collection of 7,249 species with detailed botanical
information, such as accepted names, family, authorship, publication
details, and the place and date of first publication.

## Installation

You can install the `ppendemic` package from GitHub using the following
command:

``` r
pak::pak("PaulESantos/ppendemic")
```

## Data base

The ppendemic database consists of 7,249 rows and 7 columns, with each
row representing a unique endemic plant species. The columns in the
database include:

1.  `accepted_name`: The accepted scientific name of the endemic plant
    species.
2.  `accepted_family`: The family to which the plant species belongs.
3.  `accepted_name_author`: The author of the accepted scientific name.
4.  `publication_author`: The author of the publication where the
    species was described.
5.  `place_of_publication`: The place of publication of the species.
6.  `volume_and_page`: The volume and page number of the publication.
7.  `first_published`: The year of the first publication.

The database covers a total of 169 families, and it is particularly rich
in Orchidaceae, Asteraceae, Piperaceae, Solanaceae, Fabaceae,
Bromeliaceae, Melastomataceae, Araceae, Rubiaceae, and Gentianaceae
families, which have the highest number of endemic species in Peru.
