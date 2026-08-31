#' util_classify
#'
#' @description  Classify continuous landscapes into landscapes with discrete classes
#'
#' @details
#' Mode 1: Calculate the optimum breakpoints using Jenks natural
#'     breaks optimization, the number of classes is determined with `n`.
#'     The Jenks optimization seeks to minimize the variance within categories,
#'     while maximizing the variance between categories.
#'
#' Mode 2: The number of elements in the weighting vector determines the number of classes
#'     in the resulting matrix. The classes start with the value 1.
#'     If non-numerical levels are required, the user can specify a vector to turn the
#'     numerical factors into other data types, for example into character strings (i.e. class labels).
#'     If the numerical vector of weightings does not sum up to 1, the sum of the
#'     weightings is divided by the number of elements in the weightings vector and this is then used for the classification.
#'
#' Mode 3: For a given 'real' landscape the number of classes and the weightings are
#'     extracted and used to classify the given landscape (any given weighting parameter is
#'     overwritten in this case!). If an optional mask value is given the corresponding
#'     class from the 'real' landscape is cut from the landscape beforehand.
#'
#' @param x SpatRaster
#' @param n Number of classes
#' @param weighting Vector of numeric values that are considered to be habitat percentages (see details)
#' @param level_names Vector of names for the factor levels.
#' @param real_land SpatRaster with real landscape (see details)
#' @param mask_val Value to mask (refers to real_land)
#'
#' @return SpatRaster
#'
#' @examples
#' \dontrun{
#' # Mode 1
#' util_classify(fractal_landscape,
#'               n = 3,
#'               level_names = c("Land Use 1", "Land Use 2", "Land Use 3"))
#'
#' # Mode 2
#' util_classify(fractal_landscape,
#'               weighting = c(0.5, 0.25, 0.25),
#'               level_names = c("Land Use 1", "Land Use 2", "Land Use 3"))
#'
#' # Mode 3
#' real_land <- util_classify(gradient_landscape,
#'               n = 3,
#'               level_names = c("Land Use 1", "Land Use 2", "Land Use 3"))
#'
#' fractal_landscape_real <- util_classify(fractal_landscape, real_land = real_land)
#' fractal_landscape_mask <- util_classify(fractal_landscape, real_land = real_land, mask_val = 1)
#'
#' landscapes <- list(
#' '1 nlm' = fractal_landscape,
#' '2 real' = real_land,
#' '3 result' = fractal_landscape_real,
#' '4 result with mask' = fractal_landscape_mask
#' )
#'
#' raster::plot(landscapes)
#' }
#'
#' @aliases util_classify
#' @rdname util_classify
#'
#' @export

util_classify <- function(x,
                          n = NULL,
                          weighting = NULL,
                          level_names = NULL,
                          real_land = NULL,
                          mask_val = NULL) {
  if (!inherits(x, "SpatRaster")) {
    stop("util_classify() only supports SpatRaster inputs.")
  }

  UseMethod("util_classify")
}

#' @name util_classify
#' @export
util_classify.SpatRaster <- function(x,
                          n = NULL,
                          weighting = NULL,
                          level_names = NULL,
                          real_land = NULL,
                          mask_val = NULL) {

  if (!is.null(n)) {
    checkmate::assert_count(n, positive = TRUE)
  }
  if (!is.null(weighting)) {
    checkmate::assert_numeric(weighting, any.missing = TRUE)
  }
  if (!is.null(level_names)) {
    checkmate::assert_character(level_names, min.len = 1)
  }
  if (!is.null(mask_val)) {
    checkmate::assert_numeric(mask_val, len = 1, any.missing = FALSE)
  }

  if (!is.null(real_land) && !inherits(real_land, "SpatRaster")) {
    stop("real_land must be a SpatRaster object.")
  }

  if (!is.null(real_land) && !terra::compareGeom(x, real_land, stopOnError = FALSE)) {
    stop("x and real_land must have matching geometry.")
  }

  if (!is.null(weighting) && !is.null(n)) {
    warning("If both n and weighting are used, util_classify() will use weighting.")
  }

  if (!is.null(real_land)) {
    if (!is.null(mask_val)) {
      x <- terra::mask(x, real_land, maskvalues = mask_val)
    }

    real_vals <- as.vector(terra::values(real_land, mat = FALSE))
    if (!is.null(mask_val)) {
      real_vals <- real_vals[real_vals != mask_val]
    }
    real_vals <- real_vals[!is.na(real_vals)]
    if (length(real_vals) == 0) {
      stop("real_land contains no values after masking.")
    }
    weighting <- as.numeric(table(real_vals) / sum(table(real_vals)))
    x <- .classify_spatraster(x, weighting)

  } else {
    if (is.null(weighting)) {
      if (is.null(n)) {
        stop("Either n, weighting, or real_land must be supplied.")
      }
      x_vals <- as.vector(terra::values(x, mat = FALSE))
      x_vals <- x_vals[!is.na(x_vals)]
      breaks <- .getJenksBreaks(x_vals, n)
      terra::values(x) <- as.integer(base::cut(as.vector(terra::values(x, mat = FALSE)),
                                               breaks = breaks,
                                               include.lowest = TRUE,
                                               labels = FALSE))
    } else {
      x <- .classify_spatraster(x, weighting)
    }
  }

  if (!is.null(level_names)) {
    x <- terra::as.factor(x)
    lv <- levels(x)[[1]]
    if (length(level_names) < nrow(lv)) {
      stop("level_names must have at least as many entries as classes.")
    }
    lv[[2]] <- level_names[lv$ID]
    levels(x) <- list(lv)
  }

  x
}

.classify_spatraster <- function(x, weighting){

  # Calculate cum. proportions and boundary values ----
  cumulative_proportions <- util_w2cp(weighting)
  x_vals <- as.vector(terra::values(x, mat = FALSE))
  boundary_values <- util_calc_boundaries(x_vals,
                                          cumulative_proportions)

  # If there is just one boundary value, all categories are set to one ----
  if (length(unique(boundary_values)) == 1) {
    terra::values(x) <- 1L
    return(x)
  }

  # Classify the matrix based on the boundary values ----
  terra::values(x) <- as.integer(base::cut(as.vector(terra::values(x, mat = FALSE)),
                                           breaks = c(0, boundary_values),
                                           include.lowest = TRUE,
                                           labels = FALSE))

  x

}

.getJenksBreaks <- function(var, k) {

  #if more breaks than unique values, segfault, so avoid
  if (k > length(unique(var))) {
    k <- length(unique(var));
  }
  d <- sort(var)
  return(rcpp_get_jenksbreaks(d, k))
}

util_w2cp <- function(weighting) {
  na <- sum(is.na(weighting))
  if (na > 0) {
    na_replace <- (1 - sum(weighting, na.rm = TRUE)) / na
    weighting[is.na(weighting)] <- na_replace
  }

  w <- weighting
  if (any(w < 0, na.rm = TRUE)) {
    stop("weighting must be non-negative.")
  }
  total <- sum(w, na.rm = TRUE)
  if (isTRUE(all.equal(total, 0))) {
    stop("weighting must sum to a positive value.")
  }
  proportions <- w / total
  cumulative_proportions <- cumsum(proportions)
  return(cumulative_proportions)
}

# util_calc_boundaries
# 
# @description Determine upper class boundaries for classification of a vector with values ranging 0-1 based upon an
# vector of cumulative proportions.
# 
# @param x vector of data values.
# @param cumulative_proportions Vector of class cumulative proportions, as generated by `w2cp`.
# 
# 
# @return Numerical vector with boundaries for matrix classification
# 
# 
# @examples
# x <- matrix(runif(100,0,1),10,10)
# y <- util_w2cp(c(0.5, 0.25, 0.25)) #cumulative proportion
# util_calc_boundaries(x,y)

util_calc_boundaries <- function(x, cumulative_proportions) {

  # remove na (e.g. if cells are masked from classify)
  if (any(is.na(x))) {
      x <- x[!is.na(x)]
  }

  # Get number of cells  ----
  n_cells <- length(x)

  # Use number of cells to find index of upper boundary element ----
  boundary_indexes <- as.integer( (cumulative_proportions * n_cells))

  # Get boundary values ----
  boundary_values <- sort(as.vector(x))[boundary_indexes]

  return(boundary_values)
}