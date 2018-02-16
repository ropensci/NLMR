
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.org/marcosci/NLMR.svg?branch=develop)](https://travis-ci.org/marcosci/NLMR) [![Build status](https://ci.appveyor.com/api/projects/status/ns75pdrbaykxc865?svg=true)](https://ci.appveyor.com/project/marcosci/nlmr) [![codecov](https://codecov.io/gh/marcosci/NLMR/branch/develop/graph/badge.svg?token=MKCm2fVrDa)](https://codecov.io/gh/marcosci/NLMR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/NLMR)](https://cran.r-project.org/package=NLMR) [![Join the chat at https://gitter.im/NLMR\_landscapegenerator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/NLMR_landscapegenerator) [![](http://cranlogs.r-pkg.org/badges/grand-total/NLMR)](http://cran.rstudio.com/web/packages/NLMR/index.html) [![](https://badges.ropensci.org/188_status.svg)](https://github.com/ropensci/onboarding/issues/188)

NLMR <img src="vignettes/logo.png" align="right"  height="175" />
=================================================================

`NLMR` is an `R` package for simulating **n**eutral **l**andscape **m**odels (NLM). Designed to be a generic framework like [NLMpy](https://pypi.python.org/pypi/nlmpy), it leverages the ability to simulate the most common NLM that are described in the ecological literature. `NLMR` builds on the advantages of the `raster`-package and returns all simulation as `RasterLayer`-objects, thus ensuring a direct compability to common GIS tasks and a pretty flexible and simple usage.

Installation
------------

Install the release version from CRAN:

``` r
install.packages("NLMR")
```

To install the developmental version of `NLMR`, use the following R code:

``` r
# install.packages("devtools")
devtools::install_github("marcosci/NLMR", ref = "develop")
```

Example
-------

Here we will provide a simple example on using `NLMR`:

``` r
library(NLMR)
library(magrittr)
library(ggplot2)  # to extend the plot functionality of NLMR 
library(SDMTools) # to calculate basic landscape metrics

# Simulate 50x50 rectangular cluster raster
nlm_raster <- nlm_randomrectangularcluster(50,50, resolution = 1, minl = 3, maxl = 7)

# Plot the NLM
util_plot(nlm_raster) +
  labs(title="Random rectangular cluster NLM \n (50x50 cells)")
#> Warning in seq.default(.limits[1], .limits[2], length = guide$nbin):
#> partial argument match of 'length' to 'length.out'
```

<img src="vignettes/README-unnamed-chunk-4-1.png" style="display: block; margin: auto;" />

``` r

# Classify into 3 categories
nlm_raster <- nlm_raster %>%
                 util_classify(., c(0.5, 0.25, 0.25))

# Plot the classified NLM
util_plot(nlm_raster, discrete = TRUE) +
  labs(title="Random rectangular cluster NLM \n (50x50 cells)")
```

<img src="vignettes/README-unnamed-chunk-4-2.png" style="display: block; margin: auto;" />

``` r

# Calculate basic landscape metrics
raster::as.matrix(nlm_raster) %>% 
  PatchStat() %>% 
  knitr::kable()
```

|  patchID|  n.cell|  n.core.cell|  n.edges.perimeter|  n.edges.internal|  area|  core.area|  perimeter|  perim.area.ratio|  shape.index|  frac.dim.index|  core.area.index|
|--------:|-------:|------------:|------------------:|-----------------:|-----:|----------:|----------:|-----------------:|------------:|---------------:|----------------:|
|        0|    1249|          569|                772|              4224|  1249|        569|        772|         0.6180945|     5.436620|        1.476190|        0.4555645|
|        1|     625|          165|                644|              1856|   625|        165|        644|         1.0304000|     6.440000|        1.578627|        0.2640000|
|        2|     626|          224|                552|              1952|   626|        224|        552|         0.8817891|     5.411765|        1.530357|        0.3578275|

Citation
--------


    To cite NLMR in publications use:

      Marco Sciaini, Matthias Fritsch, Craig E. Simpkins (2018).
      {NLMR}: Simulating neutral landscape models. R package version
      0.2.0. URL https://CRAN.R-project.org/package=NLMR

    A BibTeX entry for LaTeX users is

      @Misc{,
        title = {{NLMR}: Simulating neutral landscape models.},
        author = {Marco Sciaini and Matthias Fritsch and Craig E. Simpkins},
        note = {R package version 0.2.1},
        url = {https://CRAN.R-project.org/package=NLMR},
      }

Additionally, we keep a [record of publications](https://marcosci.github.io/NLMR/articles/publication_record.html/) that use`NLMR`. Hence, if you used `NLMR` please [file an issue on GitHub](https://github.com/marcosci/NLMR/issues/new/) so we can add it to the list.

Contributor Code of Conduct
---------------------------

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

Dependencies
------------

`NLMR` imports many great packages that it depends on. Many thanks to the developers of these tools:

     [1] "R (>= 3.1.0)"  " checkmate"    " dismo"        " dplyr"       
     [5] " ggplot2"      " igraph"       " magrittr"     " purrr"       
     [9] " RandomFields" " raster"       " rasterVis"    " sp"          
    [13] " spatstat"     " stats"        " tibble"       " tidyr"       
    [17] " viridis"      " extrafont"
