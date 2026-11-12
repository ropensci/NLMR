#' nlm_neigh
#'
#' @description Create a neutral landscape model with categories and clustering
#'  based on neighborhood characteristics.
#'
#' @details
#' The algorithm draws a random cell and turns it into a given category based on
#'  the probabilities \code{p_neigh} and \code{p_empty}, respectively. The decision is
#'  based on the probability \code{p_neigh}, if there is any cell in the Moore- (8 cells) or
#'  Von-Neumann-neighborhood (4 cells), otherwise it is based on \code{p_empty}. To create
#'  clustered neutral landscape models, \code{p_empty} should be (significantly) smaller than
#'  \code{p_neigh}. By default, the Von-Neumann-neighborhood is used to check adjacent
#'  cells. The algorithm starts with the highest categorical value. If the
#'  proportion of cells with this value is reached, the categorical value is
#'  reduced by 1. By default, a uniform distribution of the categories is
#'  applied.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param p_neigh [\code{numerical(1)}]\cr
#' Probability of a cell will turning into a value if there is any neighbor with the same or a
#'  higher value. Must be greater than zero and at most one.
#' @param p_empty [\code{numerical(1)}]\cr
#' Probability a cell receives a value if all neighbors have no value (i.e.
#' zero). Must be greater than zero and at most one.
#' @param categories [\code{numerical(1)}]\cr
#' Number of categories used.
#' @param neighbourhood [\code{numerical(1)}]\cr
#' The neighbourhood used to determined adjacent cells: `8 ("Moore")` takes the eight
#' surrounding cells, while `4 ("Von-Neumann")` takes the four adjacent cells
#' (i.e. left, right, upper and lower cells).
#' @param proportions [\code{vector(1)}]\cr
#' The algorithm uses uniform proportions for each category by default. A
#' non-negative vector with one value per category and a sum of one can be used
#' for other distributions.
#' @param user_seed [\code{numerical(1)}]\cr
#' Set random seed for the simulation.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#' @return SpatRaster
#'
#' @references
#' Scherer, Cédric, et al. "Merging trait-based and individual-based modelling:
#' An animal functional type approach to explore the responses of birds to
#' climatic and land use changes in semi-arid African savannas."
#' \emph{Ecological Modelling} 326 (2016): 75-89.
#'
#' @examples
#' # simulate neighborhood model
#' neigh_raster <- nlm_neigh(ncol = 50, nrow = 50, p_neigh = 0.7, p_empty = 0.1,
#'                     categories = 5, neighbourhood = 4)
#'
#' \dontrun{
#' # visualize the NLM
#' terra::plot(neigh_raster)
#' }
#'
#' @aliases nlm_neigh
#' @rdname nlm_neigh
#'
#' @export

nlm_neigh <-
  function(ncol,
           nrow,
           resolution = 1,
           p_neigh,
           p_empty,
           categories = 3,
           neighbourhood = 4,
           proportions = NA,
           user_seed = NULL,
           rescale = TRUE) {

    # Check function arguments ----
    checkmate::assert_count(ncol, positive = TRUE)
    checkmate::assert_count(nrow, positive = TRUE)
    checkmate::assert_number(p_empty, lower = 0, upper = 1)
    checkmate::assert_number(p_neigh, lower = 0, upper = 1)
    checkmate::assert_count(categories, positive = TRUE)
    checkmate::assert_true(neighbourhood == 4 || neighbourhood == 8)
    checkmate::assert_integerish(user_seed, len = 1, lower = 1, null.ok = TRUE)
    checkmate::assert_logical(rescale)

    if (p_empty == 0 || p_neigh == 0) {
      stop("`p_empty` and `p_neigh` must be greater than zero.", call. = FALSE)
    }

    if (length(proportions) == 1L && is.na(proportions)) {
      proportions <- rep(1 / categories, categories)
    } else {
      checkmate::assert_numeric(proportions, len = categories, lower = 0,
                                finite = TRUE, any.missing = FALSE)

      if (abs(sum(proportions) - 1) > sqrt(.Machine$double.eps)) {
        stop("`proportions` must sum to one.", call. = FALSE)
      }
    }

    proportions <- proportions / sum(proportions)

    # Determine cells per category
    cat <- categories - 1
    n_cells <- nrow * ncol
    no_cat <- as.integer(floor(proportions * n_cells))
    no_cat[1] <- no_cat[1] + as.integer(n_cells - sum(no_cat))

    # Create an empty matrix of correct dimensions ----
    mat <- matrix(as.integer(0), nrow, ncol)

    # Keep applying random clusters until all elements have a value -----
    seed <- if (is.null(user_seed)) sample.int(.Machine$integer.max, 1) else as.integer(user_seed)
    mat <- rcpp_neigh(nrow, ncol, mat, cat, no_cat, neighbourhood, p_neigh, p_empty, seed)

    # Transform to raster ----
    rndneigh_raster <- terra::rast(mat)

    # specify resolution ----
    terra::ext(rndneigh_raster) <- c(0,
                                     terra::ncol(rndneigh_raster) * resolution,
                                     0,
                                     terra::nrow(rndneigh_raster) * resolution)

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      rndneigh_raster <- util_rescale(rndneigh_raster)
    }

    rndneigh_raster <- util_update_metadata(rndneigh_raster)

    return(rndneigh_raster)
  }
