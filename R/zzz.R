# Adapted from: https://github.com/geanders/hurricaneexposure/blob/master/R/zzz.R

.pkgenv <- new.env(parent = emptyenv())

.onLoad  <- function(libname, pkgname) {

  has_data <- all(requireNamespace("RandomFields", quietly = TRUE),
                  requireNamespace("RandomFieldsUtils", quietly = TRUE))

  .pkgenv[["has_data"]] <- has_data

}

.onAttach <- function(libname, pkgname) {

  if (!.pkgenv$has_data) {

    message <- paste("Some functions in this package require the 'RandomFields'",
                     "and 'RandomFieldsUtil' packages which are not available on CRAN anymore.",
                     "To install them, please run 'install.packages('RandomFields',",
                     "repos = 'https://predictiveecology.r-universe.dev', type = 'source')'.")

    message <- paste(strwrap(message), collapse = "\n")

    packageStartupMessage(message)

  }
}

hasData <- function(has_data = .pkgenv$has_data) {

  if (!has_data) {

    message <- paste("This function requires the 'RandomFields' or 'RandomFieldsUtil'",
                     "packages which are not available on CRAN anymore. To install them,",
                     "please run 'install.packages('RandomFields',",
                     "repos = 'https://predictiveecology.r-universe.dev', type = 'source')'.")

    message <- paste(strwrap(message), collapse = "\n")

    stop(message, call. = FALSE)
  }
}
