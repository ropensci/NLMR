#' nlm_randomrectangularcluster
#'
#' Simulates a random rectangular clusters neutral landscape model with values ranging 0-1.
#'
#' @param ncol [\code{numerical(1)}]\cr Number of columns forming the raster.
#' @param nrow  [\code{numerical(1)}]\cr Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr Resolution of the raster.
#' @param minl [\code{numerical(1)}]\cr The minimum possible width and height for each random rectangular cluster.
#' @param maxl [\code{numerical(1)}]\cr The maximum possible width and height for each random rectangular cluster.
#' @param rescale [\code{logical(1)}]\cr If \code{TRUE} (default), the values are rescaled between 0-1.
#'
#' @details
#' The random rectangular cluster algorithm starts to fill a raster randomly
#' with rectangles defined by \code{minl} and \code{maxl} until the surface
#' of the landscape is completely covered.
#' This is one type of realisation of a "falling/dead leaves" algorithm,
#' for more details see Galerne & Gousseau (2012).
#'
#' @return RasterLayer
#'
#' @references
#' Gustafson, E.J. & Parker, G.R. (1992). Relationships between landcover
#' proportion and indices of landscape spatial pattern. \emph{Landscape ecology},
#' 7, 101–110.
#' Galerne B. & Gousseau Y. (2012). The Transparent Dead Leaves Model. Advances in
#' Applied Probability, \emph{Applied Probability Trust}, 44, 1–20.
#'
#' @examples
#' # simulate random rectangular cluster
#' randomrectangular_cluster <- nlm_randomrectangularcluster(ncol = 50,
#'                                                           nrow = 30,
#'                                                           minl = 5,
#'                                                           maxl = 10)
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(randomrectangular_cluster)
#' }
#'
#' @aliases nlm_randomrectangularcluster
#' @rdname nlm_randomrectangularcluster
#'
#' @export
#'

nlm_randomrectangularcluster <-
  function(ncol,
           nrow,
           resolution = 1,
           minl,
           maxl,
           rescale = TRUE) {
    # Check function arguments ----
    checkmate::assert_count(ncol, positive = TRUE)
    checkmate::assert_count(nrow, positive = TRUE)
    checkmate::assert_numeric(resolution)
    checkmate::assert_count(minl, positive = TRUE)
    checkmate::assert_count(maxl, positive = TRUE)
    checkmate::assert_true(minl <= ncol)
    checkmate::assert_true(minl <= nrow)
    checkmate::assert_true(maxl <= ncol)
    checkmate::assert_true(maxl <= nrow)
    checkmate::assert_true(minl <= maxl)
    checkmate::assert_logical(rescale)

    # Create the landscape matrix with rcpp_randomrectangularcluster  ----
    seed <- sample.int(.Machine$integer.max, 1)
    matrix <- rcpp_randomrectangularcluster(ncol = ncol,
                                            nrow = nrow,
                                            minl = minl,
                                            maxl = maxl,
                                            seed)

    # Transform to raster ----
    rndreccluster_raster <- raster::raster(matrix)

    # specify resolution ----
    raster::extent(rndreccluster_raster) <- c(
      0,
      ncol(rndreccluster_raster) * resolution,
      0,
      nrow(rndreccluster_raster) * resolution
    )

    # Rescale values to 0-1 ----
    if (rescale == TRUE) {
      rndreccluster_raster <-
        util_rescale(rndreccluster_raster)
    }

    return(rndreccluster_raster)
  }
