# plotme

------------------------------------------------------------------------

The `{plotme}` package provides a human friendly interface for plots that are otherwise quite hard to create in R. Currently only functions exist, to create ***sunburst*** and ***treemap*** plots from `{plotly}`, but (hopefully) more is to come.

## Installation

    devtools::install_github("yogevherz/plotme"")

## Usage

The `count_to_sunburst()` and `count_to_treemap()` are built to help you quickly create interactive hierarchical plots from categorical data. This can be very handy when exploring a new dataset. The function expect the a summary of the data created by `dplyr::count()`.

Quickly create a ***sunburst*** plot:
```r
library(plotme)
library(dplyr)
library(palmer)

penguins %>% 
  count(island, species, sex) %>% 
  count_to_sunburst()
```
To change the hierarchy, simply change the order in the `count()` call:
```r
penguins %>% 
  count(species, island, sex) %>% 
  count_to_sunburst()
```
Color groups by size:
``` r
penguins %>% 
  count(species, island, sex) %>% 
  count_to_sunburst(fill_by_n = TRUE)
```
Make group size promotional to the sum of another variable:
``` r
penguins %>% 
  count(species, island, sex, wt = body_mass_g) %>% 
  count_to_sunburst(fill_by_n = TRUE)
```
Works the same for a ***treemap*** plot:
```r
penguins %>% 
  count(species, island, sex, wt = body_mass_g) %>% 
  count_to_treemap(fill_by_n = TRUE)
```
