# plotme

------------------------------------------------------------------------

The `{plotme}` package provides a human friendly interface for plots that are otherwise quite hard to create in R. Currently only functions exist, to create ***sunburst*** and ***treemap*** plots from `{plotly}`, but (hopefully) more is to come.

## Installation

    devtools::install_github("yogevherz/plotme"")

## Usage

``` r
library(plotme)
library(dplyr)
library(palmerpenguins)
```

The `count_to_sunburst()` and `count_to_treemap()` are built to help you quickly create interactive hierarchical plots from categorical data. This can be very handy when exploring a new dataset. The function expect the a summary of the data created by `dplyr::count()`.

Quickly create a ***sunburst*** plot:

``` r
penguins %>% 
  count(island, species, sex) %>% 
  count_to_sunburst()
```

<img src="man/figures/readme.gif" width="510"/>

To change the hierarchy, simply change the order in the `count()` call:

``` r
penguins %>% 
  count(species, island, sex) %>% 
  count_to_sunburst()
```

<img src="man/figures/paste-86908F21.png" width="507"/>

Color groups by size:

``` r
penguins %>% 
  count(species, island, sex) %>% 
  count_to_sunburst(fill_by_n = TRUE)
```

<img src="man/figures/paste-9883B116.png" width="582"/>

Make group size proportional to the sum of another variable (instead of observation count):

``` r
penguins %>% 
  count(species, island, sex, wt = body_mass_g) %>% 
  count_to_sunburst(fill_by_n = TRUE)
```

<img src="man/figures/paste-E2F67398.png" width="586"/>

Works the same for a ***treemap*** plot:

``` r
penguins %>% 
  count(species, island, sex, wt = body_mass_g) %>% 
  count_to_treemap(fill_by_n = TRUE)
```

<img src="man/figures/readme2.gif" width="579"/>
