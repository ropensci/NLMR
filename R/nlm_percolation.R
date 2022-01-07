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
#' @param crs [\code{character(1)}]\cr
#' Coordinate reference system for new raster. If blank, defaults to WGS 84.
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
#' @return SpatRaster
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
                            prob = 0.5,
                            crs = "+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs") {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_true(prob <= 1, na.ok = FALSE)
  checkmate::assert_true(prob >= 0, na.ok = FALSE)
    
  percolation_raster = terra::rast(nrows = nrow, ncols = ncol, nlyrs=1,
                                   resolution = resolution,
                                   extent = c(0, ncol * resolution,
                                              0, nrow * resolution),
                                   crs = crs,
                                   vals = sample(c(0,1), 
                                                 size = ncol * nrow, 
                                                 replace = T, 
                                                 prob = c(1-prob, prob)))

  return(percolation_raster)
}
