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
#'     weightings is divided by the number of elements in the weightings vector and this is then used for the classificat#'     .
#'
#' Mode 3: For a given 'real' landscape the number of classes and the weightings are
#'     extracted and used to classify the given landscape (any given weighting parameter is
#'     overwritten in this case!). If an optional mask value is given the corresponding
#'     class from the 'real' landscape is cut from the landscape beforehand.
#'
#' @param x raster
#' @param n Number of classes
#' @param weighting Vector of numeric values that are considered to be habitat percentages (see details)
#' @param level_names Vector of names for the factor levels.
#' @param real_land Raster with real landscape (see details)
#' @param mask_val Value to mask (refers to real_land)
#'
#' @return RasterLayer
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
                          n,
                          weighting,
                          level_names,
                          real_land,
                          mask_val) UseMethod("util_classify")

#' @name util_classify
#' @export
util_classify.RasterLayer <- function(x,
                          n = NULL,
                          weighting = NULL,
                          level_names = NULL,
                          real_land = NULL,
                          mask_val = NULL) {

  # Check input
  if (!is.null(weighting) & !is.null(n)) warning("If n AND weighting are used, util_classify will fallback to weighting as classification method.")

  # Classify based on real landscape ----
  if (!is.null(real_land)) {

      if(!inherits(real_land, "RasterLayer")) stop("real_land muste be a RasterLayer object.")

      frq <- raster::freq(real_land)
      if (!is.null(mask_val)) {
        frq <- frq[frq[,1] != mask_val, ]
        x <- raster::mask(x, real_land, maskvalue = mask_val)
      }
      weighting <- frq[,2] / sum(frq[,2])

      x <- .classify(x, weighting)

  } else {

    if (is.null(weighting)){
      breaks <- .getJenksBreaks(raster::getValues(x), n)
      x <-  raster::cut(x, breaks=breaks, include.lowest = TRUE)
    } else {
      x <- .classify(x, weighting)
    }

  }

  # If level_names are not NULL, add them as specified ----
  if (!is.null(level_names)) {

    # Turn raster values into factors ----
    x <- raster::as.factor(x)

    c_r_levels <- raster::levels(x)[[1]]
    c_r_levels[["Categories"]] <- level_names[c_r_levels$ID]
    levels(x) <- c_r_levels
  }

  return(x)
}

.classify <- function(x, weighting){

  # Calculate cum. proportions and boundary values ----
  cumulative_proportions <- util_w2cp(weighting)
  boundary_values <- util_calc_boundaries(raster::values(x),
                                          cumulative_proportions)

  # If there is just one boundary value, all categories are set to one ----
  if (length(unique(boundary_values)) == 1) {
    raster::values(x) <- 1
    return(x)
  }

  # Classify the matrix based on the boundary values ----
  raster::values(x) <-  base::cut(raster::values(x),
                                  breaks = c(0, boundary_values),
                                  include.lowest = TRUE, labels = FALSE)

  return(x)

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
  na_replace <- (1 - sum(weighting, na.rm = TRUE)) / na
  weighting[is.na(weighting)] <- na_replace
  
  w <- weighting
  proportions <- w / sum(w)
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