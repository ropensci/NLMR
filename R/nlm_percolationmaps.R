#' nlm_percolation
#'
#' @description Create a random percolation map.
#'
#' @param nCol [\code{numerical(1)}]\cr
#' Number of columns for the raster.
#' @param nRow [\code{numerical(1)}]\cr
#' Number of rows for the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param prob [\code{numerical(1)}]\cr
#' Probability value for setting a cell either to 0 or 1.
#'
#' @details
#' The simulation of a random percolation map is accomplished in two steps:
#'
#' \itemize{
#'  \item{Initialization: }{ Setup matrix of size (\code{nCol}*\code{nRow})}
#'  \item{Map generation: }{ For each cell in the matrix a single uniformly
#'  distributed random number is generated and tested against a probability
#'  \code{p}. If the random number is smaller than \code{p}, the cell is set to
#'  1 - if it is higher the cell is set to 0.}
#' }
#'
#' The proportion of 0 and 1 is thus controlled with the argument \code{p}.
#'
#' @return RasterLayer
#'
#' @examples
#' nlm_percolation(nCol = 100, nRow = 100, prob=0.5)
#'
#' @references
#' 1. Gardner RH, O’Neill R V, Turner MG, Dale VH. 1989. Quantifying
#' scale-dependent effects of animal movement with simple percolation models.
#' \emph{ Landscape Ecology} 3:217–227.
#' 2. Gustafson, E.J. & Parker, G.R. (1992) Relationships between landcover
#' proportion and indices of landscape spatial pattern. \emph{Landscape Ecology}
#' , 7, 101–110.
#'
#' @aliases nlm_percolation
#' @rdname nlm_percolation
#'
#' @export
#'

nlm_percolation  <- function(nCol,
                             nRow,
                             resolution = 1,
                             prob = 0.5) {

  # Check function arguments ----
  checkmate::assert_count(nCol, positive = TRUE)
  checkmate::assert_count(nRow, positive = TRUE)
  checkmate::assert_true(prob <= 1, na.ok = FALSE)
  checkmate::assert_true(prob >= 0, na.ok = FALSE)

  percolation_matrix <- matrix(NA, nrow = nRow, ncol = nCol)

  percolation_matrix[] <- vapply(percolation_matrix,
                                 function(x){
                                   ifelse(stats::runif(1,0,1) < prob, 1, 0)
                                   },
                                 numeric(1))

  percolation_raster <-
    raster::raster(percolation_matrix)

  # specify resolution ----
  raster::extent(percolation_raster) <- c(0,
                                  ncol(percolation_raster)*resolution,
                                  0,
                                  nrow(percolation_raster)*resolution)

  return(percolation_raster)

}
