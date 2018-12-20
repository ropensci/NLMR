#' nlm_percolation
#'
#' @description Generates a random percolation neutral landscape model.
#'
#' @param ncol [\code{numerical(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow [\code{numerical(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param prob [\code{numerical(1)}]\cr
#' Probability value for setting a cell to 1.
#'
#' @details
#' The simulation of a random percolation map is accomplished in two steps:
#'
#' \itemize{
#'  \item{Initialization: }{ Setup matrix of size (\code{ncol}*\code{nrow})}
#'  \item{Map generation: }{ For each cell in the matrix a single uniformly
#'  distributed random number is generated and tested against a probability
#'  \code{prob}. If the random number is smaller than \code{prob}, the cell is set to
#'  TRUE - if it is higher the cell is set to FALSE.}
#' }
#'
#' @return RasterLayer
#'
#' @examples
#' # simulate percolation model
#' percolation <- nlm_percolation(ncol = 100, nrow = 100, prob = 0.5)
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(percolation)
#' }
#' @references
#' 1. Gardner RH, O'Neill R V, Turner MG, Dale VH. 1989. Quantifying
#' scale-dependent effects of animal movement with simple percolation models.
#' \emph{ Landscape Ecology} 3:217 - 227.
#'
#' 2. Gustafson, E.J. & Parker, G.R. (1992) Relationships between landcover
#' proportion and indices of landscape spatial pattern. \emph{Landscape Ecology}
#' , 7, 101 - 110.
#'
#' @aliases nlm_percolation
#' @rdname nlm_percolation
#'
#' @export
#'

nlm_percolation <- function(ncol,
                            nrow,
                            resolution = 1,
                            prob = 0.5) {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_true(prob <= 1, na.ok = FALSE)
  checkmate::assert_true(prob >= 0, na.ok = FALSE)

  percolation_matrix <- matrix(NA, nrow = nrow, ncol = ncol)

  percolation_matrix[] <- vapply(
    percolation_matrix,
    function(x) {
      ifelse(stats::runif(1, 0, 1) < prob, TRUE, FALSE)
    },
    logical(1)
  )

  percolation_raster <-
    raster::raster(percolation_matrix)

  # specify resolution ----
  raster::extent(percolation_raster) <- c(
    0,
    ncol(percolation_raster) * resolution,
    0,
    nrow(percolation_raster) * resolution
  )

  return(percolation_raster)
}
