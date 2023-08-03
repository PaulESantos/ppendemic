
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ppendemic <a href='https://github.com/PaulESantos/ppendemic'><img src='man/figures/cover_ppendemic.jpg' align="right" height="220" width="150" /></a>

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

<blockquote align="center">
…El libro rojo de las plantas endémicas del Perú constituye, en este
aspecto una herramienta fundamental para determinar las medidas
necesarias para la conservación de la flora peruana. - Kember Mejía
Carhuanca
</blockquote>

The flora of Peru is one of the richest in the New World, with over
14,000 species, and 5,508 taxa are treated as endemic. This represents a
significant proportion of the South American flora, highlighting the
importance of Peru in the conservation of New World flora.

The pandemic package takes the data from the **The red book of endemic
plants of Peru** and update the taxonomic information for all species
included using the [Taxonomic Name Resolution
Service](https://tnrs.biendata.org/) api.

The goal of ppendemic is to provide access to the endemic plant species
data in Peru.

## Installation:

You can install the latest development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("PaulESantos/ppendemic")
```

## About the data

Data were published and made available by the [Revista Peruana de
Biología](https://revistasinvestigacion.unmsm.edu.pe/index.php/rpb/index)
in volume 13 and number 2 [available
here](https://revistasinvestigacion.unmsm.edu.pe/index.php/rpb/issue/view/153),
on 2006. Edited by Blanca León et al.

## Citation

To cite the ppendemic package, please use:

``` r
citation("ppendemic")
```

## References

**Data originally published in:**

- León, B., Pitman, N., & Roque Gamarra, J. E. (2006). Introducción a
  las plantas endémicas del Perú. Revista Peruana de Biologia, 13(2),
  9s-22s.
  [Here](https://revistasinvestigacion.unmsm.edu.pe/index.php/rpb/issue/view/153)
