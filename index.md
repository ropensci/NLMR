
[![Build Status](https://travis-ci.org/marcosci/nlmr.svg?branch=develop)](https://travis-ci.org/marcosci/nlmr) [![Build status](https://ci.appveyor.com/api/projects/status/ns75pdrbaykxc865?svg=true)](https://ci.appveyor.com/project/marcosci/nlmr) [![codecov](https://codecov.io/gh/marcosci/nlmr/branch/develop/graph/badge.svg?token=MKCm2fVrDa)](https://codecov.io/gh/marcosci/nlmr) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/nlmr)](https://cran.r-project.org/package=nlmr) [![Join the chat at https://gitter.im/nlmr\_landscapegenerator](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/nlmr_landscapegenerator) [![](http://cranlogs.r-pkg.org/badges/grand-total/nlmr)](http://cran.rstudio.com/web/packages/nlmr/index.html) [![](https://badges.ropensci.org/188_status.svg)](https://github.com/ropensci/onboarding/issues/188)

<i class="fa fa-code" aria-hidden="true"></i> **nlmr** <img src="vignettes/logo.png" align="right" height="175" />
------------------------------------------------------------------------------------------------------------------

**N**eutral **L**andscape **M**odels with **R**

------------------------------------------------------------------------

**nlmr** is an `R` package for simulating **n**eutral **l**andscape **m**odels (NLM). Designed to be a generic framework like [NLMpy](https://pypi.python.org/pypi/nlmpy), it leverages the ability to simulate the most common NLM that are described in the ecological literature. `nlmr` exploits the advantages of the `raster`-package and returns all simulation as `RasterLayer`-objects, thus ensuring a direct compability to common GIS tasks and a pretty flexible and simple usage. Furthermore, it simulates NLMs within a self-contained, reproducible framework.

------------------------------------------------------------------------

<i class="fa fa-cubes" aria-hidden="true"></i> Why nlmr? <small> ... and not one of the other software tools<a href="https://marcosci.github.io/nlmr/articles/faq.html"><sup>\*</sup></a></small>
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-   It is so far the only library of NLM in `R`
    -   R is the <small>programming</small> lingua franca for ecologists
    -   Open-source + cross-platform
-   Most comprehensive collection of algorithms to simulate NLM
-   Embedded in a native GIS framework
-   Variety of utility functions (classification, merging, visualization, ...)
-   Openly developed on [github](https://github.com/marcosci/nlmr)
    -   If something is missing or annoys you - [get in touch](https://github.com/marcosci/nlmr/issues/new)
