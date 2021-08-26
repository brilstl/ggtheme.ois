
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ggtheme.ois

De `{{ggtheme.ois}}` package is bedoeld om makkelijk plots te maken in
OIS-huistijl. Het uitgangspunt is om zo snel mogelijk van dataset naar
output te komen.

## Installation

De package kan als volgt worden geïnstalleerd van
[GitHub](https://github.com/):

``` r
# install.packages("devtools")
devtools::install_github("brilstl/ggtheme.ois")
#> WARNING: Rtools is required to build R packages, but is not currently installed.
#> 
#> Please download and install Rtools 4.0 from https://cran.r-project.org/bin/windows/Rtools/.
#> Skipping install of 'ggtheme.ois' from a github remote, the SHA1 (e75d4590) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

## Example

Dit is een voorbeeld van een veel voorkomende plot binnen OIS:

``` r
library(ggtheme.ois)

likert_plot(.data = mtcars, y_as = gear, fill = carb)
```

<img src="man/figures/README-example-likert-1.png" width="100%" />

De `facet = ...` functionaliteit kan worden toegepast om meerdere
groepen onafhankelijk in een plot te tonen. Deze variabelen moet tussen
aanhalingstekens worden doorgegeven aan de functie.

``` r
likert_plot(.data = mtcars, y_as = gear, fill = carb, facet = vs)
```

<img src="man/figures/README-example-likert-facet-1.png" width="100%" />

Een andere mogelijkheid is om een donut plot te maken. De syntax is
vergelijkbaar alleen dan natuurlijk zonder de y as.

``` r
donut_plot(.data = mtcars, fill = carb, facet = 'vs')
```

<img src="man/figures/README-donut-plot-facet-1.png" width="100%" />

Een gewone bar plot kan ook gemaakt worden:

``` r
bar_plot(.data = mtcars, y_as = carb)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />
