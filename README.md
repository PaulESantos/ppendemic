
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ppendemic

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/ppendemic)](https://CRAN.R-project.org/package=ppendemic)
<!-- badges: end -->

El objetivo de ppendemic es brindar acceso a la información botánica de
“El libro rojo de las plantas endémicas del Perú. Blanca León et al
2006”.

Al momento es un proyectó en desarrollo, con el objetivó de facilitar la
determinación de endemismos en inventarios y evaluaciones botánicas del
Perú.

## Instalación:

Puede instalar la versión en desarrollo de ppendemic desde
[github](https://github.com/) con:

``` r
# install.packages("remotes")
remotes::install_github("PaulESantos/ppendemic")
```

## Ejemplo:

`pep_check`, es la función básica de `ppendemic`:

``` r
library(tidyverse)
library(ppendemic)
```

La función puede ejecutarse sobre un `vector` con los nombres de las
especies que se desea verificar.

``` r
spp <-  c("Clethra cuneata", "Miconia setulosa", "Weinmannia fagaroides", 
"Symplocos quitensis", "Miconia alpina", "Persea ruizii",
"Myrsine andina", "Symplocos baehnii", "Polylepis pauta")

pep_check(spp)
#> [1] "Clethra cuneata"       "Miconia setulosa"      "Weinmannia fagaroides"
#> [4] "Symplocos quitensis"   "endemic"               "Persea ruizii"        
#> [7] "Myrsine andina"        "endemic"               "Polylepis pauta"
```

O puede ser incluida dentro del flujo de funciones de `tidyverse`:

``` r
df <- tibble::tibble(sppe = c("Clethra cuneata", "Miconia setulosa",
                          "Weinmannia fagaroides", "Symplocos quitensis",
                          "Miconia alpina", "Persea ruizii",
                          "Myrsine andina", "Symplocos baehnii",
                          "Polylepis pauta"))

df
#> # A tibble: 9 x 1
#>   sppe                 
#>   <chr>                
#> 1 Clethra cuneata      
#> 2 Miconia setulosa     
#> 3 Weinmannia fagaroides
#> 4 Symplocos quitensis  
#> 5 Miconia alpina       
#> 6 Persea ruizii        
#> 7 Myrsine andina       
#> 8 Symplocos baehnii    
#> 9 Polylepis pauta

df %>% 
  mutate(endemic = pep_check(sppe))
#> # A tibble: 9 x 2
#>   sppe                  endemic              
#>   <chr>                 <chr>                
#> 1 Clethra cuneata       Clethra cuneata      
#> 2 Miconia setulosa      Miconia setulosa     
#> 3 Weinmannia fagaroides Weinmannia fagaroides
#> 4 Symplocos quitensis   Symplocos quitensis  
#> 5 Miconia alpina        endemic              
#> 6 Persea ruizii         Persea ruizii        
#> 7 Myrsine andina        Myrsine andina       
#> 8 Symplocos baehnii     endemic              
#> 9 Polylepis pauta       Polylepis pauta
```

Mapa de registro departamental:

``` r
#pep_regdep_map("Symplocos baehnii")
```
