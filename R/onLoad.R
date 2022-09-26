# Source: https://thecoatlessprofessor.com/programming/r/r-data-packages-in-external-data-repositories-using-the-additional_repositories-field/

.onLoad <- function(libname, pkgname) {

  repos <- getOption("repos")

  repos["getCRUCLdata"] <- "https://predictiveecology.r-universe.dev/"

  options(repos = repos)

  invisible(repos)

}
