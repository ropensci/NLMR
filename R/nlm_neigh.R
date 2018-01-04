#' nlm_neigh
#'
#' @description Create a neutral landscape model with categories and clustering
#'  based on neighborhood characteristic.
#'
#' @details
#' The algorithm draws a random cell and turns it into a given category based on
#'  the probabilities \code{p_neigh} and \code{p_empty}, respectively. The decision is
#'  based on the probability \code{p_neigh}, if there is any cell in the Moore- or
#'  Von-Neumann-neighborhood, otherwise it is based on \code{p_empty}. To create
#'  clustered neutral landscape models, \code{p_empty} should be (significantly) smaller than
#'  \code{p_neigh}. By default, the Von-Neumann-neighborhood is used to check adjacent
#'  cells. The algorithm starts with the highest categorial value. If the
#'  proportion of cells with this value is reached, the categorial value is
#'  reduced by 1. By default, a uniform distribution of the categories is
#'  applied.
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow  [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param p_neigh [\code{numerical(1)}]\cr
#' Probability to turn into a value if there is any neighbor with the same or a
#'  higher value.
#' @param p_empty [\code{numerical(1)}]\cr
#' Probability a cell receives a value if all neighbors have no value (i.e.
#' zero).
#' @param categories [\code{numerical(1)}]\cr
#' Number of categories used.
#' @param neighborhood [\code{string(1)}]\cr
#' The neighborhood used to determined adjacent cells: `"Moore"` takes the eight
#' surrounding cells, while `"Von-Neumann"` takes the four adjacent cells
#' (i.e. left, right, upper and lower cells).
#' @param proportions [\code{vector(1)}]\cr
#' The algorithm uses uniform proportions for each category by default. A vector
#' with as many proportions as categories and that sums up to 1 can be used for
#' other distributions.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values
#'                are rescaled between 0-1.
#'
#' @return RasterLayer
#'
#' @references
#' Scherer, Cédric, et al. "Merging trait-based and individual-based modelling:
#' An animal functional type approach to explore the responses of birds to
#' climatic and land use changes in semi-arid African savannas."
#' \emph{Ecological Modelling} 326 (2016): 75-89.
#'
#' @examples
#' # simulate neighborhood model
#' neigh_raster <- nlm_neigh(nCol = 20, nRow = 20, p_neigh = 0.1, p_empty = 0.3,
#'                     categories = 5, neighborhood = "Von-Neumann")
#'
#' \dontrun{
#' # visualize the NLM
#' util_plot(neigh_raster)
#' }
#'
#' @aliases nlm_neigh
#' @rdname nlm_neigh
#'
#' @export

nlm_neigh <-
  function(nCol,
           nRow,
           resolution = 1,
           p_neigh,
           p_empty,
           categories = 3,
           neighborhood = "Von-Neumann",
           proportions = NA,
           rescale = TRUE) {

    # Check function arguments ----
    checkmate::assert_count(nCol, positive = TRUE)
    checkmate::assert_count(nRow, positive = TRUE)
    checkmate::assert_numeric(p_empty)
    checkmate::assert_numeric(p_neigh)
    checkmate::assert_count(categories, positive = TRUE)
    checkmate::assert_character(neighborhood)
    checkmate::assert_vector(proportions)
    checkmate::assert_logical(rescale)

    # Determine cells per categorie
    cat <- categories - 1 ## -1 because remaining cells are category
    if (is.double(proportions)) {
      no_cat <- rev(proportions) * nRow * nCol
    } else {
      no_cat <- rep(floor(nRow * nCol / categories), cat + 1)
    }

    # Create an empty matrix of correct dimensions + additional 2 rows and
    # columns ----
    matrix <- matrix(0, nCol + 2, nRow + 2)

    # Keep applying random clusters until all elements have a value -----
    while (cat > 0) {
      j <- 0

      while (j < no_cat[cat + 1]) {

        # Pick random cell within correct dimensions and with value 0 ----
        s <- which(matrix[2:(nRow + 1), 2:(nCol + 1)] == 0, arr.ind = TRUE)
        s <- s[sample(nrow(s), 1), ]
        row <- as.integer(s[1]) + 1
        col <- as.integer(s[2]) + 1

        # Check neighborhood of that cell ----
        if (neighborhood == "Von-Neumann") {
          adjacent <- c(
            matrix[row - 1, col    ], # upper
            matrix[row, col - 1], # left
            matrix[row, col + 1], # right
            matrix[row + 1, col    ]
          ) # lower
        }
        if (neighborhood == "Moore") {
          adjacent <- c(
            matrix[row - 1, col - 1], # upper left
            matrix[row - 1, col    ], # upper
            matrix[row - 1, col + 1], # upper right
            matrix[row, col - 1], # left
            matrix[row, col + 1], # right
            matrix[row + 1, col - 1], # lower left
            matrix[row + 1, col    ], # lower
            matrix[row + 1, col + 1]
          ) # lower right
        }

        if (sum(adjacent, na.rm = TRUE) > 0) {
          if (stats::runif(1, 0, 1) < p_neigh) {
            matrix[row, col] <- cat
            j <- j + 1
          }
        } else {
          if (stats::runif(1, 0, 1) < p_empty) {
            matrix[row, col] <- cat
            j <- j + 1
          }
        }

        # Update boundary conditions
        matrix[1, ] <- matrix[nRow + 1, ]
        matrix[nRow + 2, ] <- matrix[2, ]
        matrix[, 1] <- matrix[, nCol + 1]
        matrix[, nCol + 2] <- matrix[, 2]
      } # close while j

      cat <- cat - 1
    } # close while i

    # Cut additional cells and transform to raster ----
    randomneighborhoodcluster_raster <- raster::raster(matrix[
      1:nRow + 1,
      1:nCol + 1
    ])

    # specify resolution ----
    raster::extent(randomneighborhoodcluster_raster) <- c(
      0,
      ncol(randomneighborhoodcluster_raster) * resolution,
      0,
      nrow(randomneighborhoodcluster_raster) * resolution
    )

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      randomneighborhoodcluster_raster <-
        util_rescale(randomneighborhoodcluster_raster)
    }

    return(randomneighborhoodcluster_raster)
  }
