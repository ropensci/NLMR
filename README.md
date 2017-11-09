
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Build Status](https://travis-ci.com/marcosci/NLMR.svg?token=jEyKPuKzrFUKtpg4pK2t&branch=master)](https://travis-ci.com/marcosci/NLMR) [![codecov](https://codecov.io/gh/marcosci/NLMR/branch/master/graph/badge.svg?token=MKCm2fVrDa)](https://codecov.io/gh/marcosci/NLMR) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/eNLMR)](https://cran.r-project.org/package=eNLMR) [![Join the chat at https://gitter.im/NLMR\_landscapegenerator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/NLMR_landscapegenerator) [![](http://cranlogs.r-pkg.org/badges/ggplot2)](http://cran.rstudio.com/web/packages/ggplot2/index.html)

NLMR <img src="vignettes/logo.png" align="right"  height="150" />
=================================================================

**NLMR** is an `R` package for simulating **n**eutral **l**andscape **m**odels (NLM). Designed to be a generic framework like [NLMpy](https://pypi.python.org/pypi/nlmpy), it leverages the ability to simulate the most common NLM that are described in the ecological literature. `NLMR` exploits the advantages of the `raster`-package and returns all simulation as `RasterLayer`-objects, thus ensuring a direct compability to common GIS tasks and a pretty flexible and simple usage.

Installation
------------

Install the release version from CRAN:

``` r
install.packages("NLMR")
```

To install the developmental version of `NLMR`, use the following R code:

``` r
# install.packages("devtools")
devtools::install_github("marcosci/NLMR")
```

Example
-------

Here we will provide a simple example on using `NLMR`:

``` r
library(NLMR)
library(magrittr)
library(ggplot2)  # to extent the plot functionality of NLMR 
library(SDMTools) # to calculate basic landscape metrics

# Simulate 50x50 rectangular cluster raster
nlm_raster <- nlm_randomrectangularcluster(50,50, resolution = 5, minL = 3, maxL = 7)

# Plot the NLM
util_plot(nlm_raster, scale = "B") +
  labs(title="Random rectangular cluster NLM \n (50x50 cells)")
```

![](README-example-1.png)

``` r

# Classify into 4 categories
nlm_raster <- as.matrix(nlm_raster) %>%
                 util_classify(., c(0.5, 0.25, 0.25)) %>% 
                 raster()

# Plot the classified NLM
util_plot(nlm_raster, scale = "B") +
  labs(title="Random rectangular cluster NLM \n (50x50 cells)")
```

![](README-example-2.png)

``` r

# Calculate basic landscape metrics
as.matrix(nlm_raster) %>% 
  PatchStat() %>% 
  knitr::kable()
```

|  patchID|  n.cell|  n.core.cell|  n.edges.perimeter|  n.edges.internal|  area|  core.area|  perimeter|  perim.area.ratio|  shape.index|  frac.dim.index|  core.area.index|
|--------:|-------:|------------:|------------------:|-----------------:|-----:|----------:|----------:|-----------------:|------------:|---------------:|----------------:|
|        0|    1247|          559|                786|              4202|  1247|        559|        786|         0.6303128|     5.535211|        1.481564|        0.4482759|
|        1|     620|          160|                628|              1852|   620|        160|        628|         1.0129032|     6.280000|        1.572773|        0.2580645|
|        2|     619|          227|                522|              1954|   619|        227|        522|         0.8432956|     5.220000|        1.515648|        0.3667205|
|        3|      14|            0|                 24|                32|    14|          0|         24|         1.7142857|     1.500000|        1.357878|        0.0000000|

Citation
--------

To cite package '*NLMR*' in publications please use:

    Sciaini M and Simpkins, CE (2017). NLMR: Simulating neutral landscape models with R. R package version 0.1.0. https://github.com/marcosci/NLMR.

Additionally, we keep a [record of publications](https://marcosci.github.io/NLMR/iarticles/publication_record.html) that use *NLMR*. Hence, if you used *NLMR* please [file an issue on GitHub](https://marcosci.github.io/NLMR/issues/new) so we can add it to the list.
