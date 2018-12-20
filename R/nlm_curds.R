#' nlm_curds
#'
#' @description Simulates a random curd neutral landscape model with optional wheys.
#'
#' @details Random curdling recursively subdivides the plane into blocks.
#' At each level of the recursion, a fraction of the blocks are declared as
#' habitat (value == TRUE) while the remaining blocks continue to be defined as matrix (value == FALSE) and enter the next recursive cycle.
#'
#' The optional argument (\code{wheyes}) allows wheys to be added, in which a set proportion of cells that were
#' declared matrix (value == FALSE) during recursion, are now set as habitat cells (value == TRUE).
#'
#' If \deqn{curds_{1} = curds_{2} = recursion_steps_{2} = ... = curds_{n} =
#' recursion_steps_{n}} the models resembles a binary random map.
#'
#' Note that you can not set ncol and nrow with this landscape algorithm.
#' The amount of cells and hence dimension of the raster is given by the vector product of the recursive steps.
#'
#' @param curds [\code{numerical(x)}]\cr
#' Vector with percentage/s to fill with curds (fill with habitat (value ==
#' TRUE)).
#' @param recursion_steps [\code{numerical(x)}]\cr
#' Vector of successive cutting steps for the blocks (split 1 block into \code{x}
#' blocks).
#' @param wheyes [\code{numerical(x)}]\cr
#' Vector with percentage/s to fill with wheys, which fill matrix in an
#' additional step with habitat.
#' @param resolution [\code{numerical(1)}]\cr
#' Resolution of the resulting raster.
#'
#' @return raster
#'
#' @examples
#'
#' # simulate random curdling
#' (random_curdling <- nlm_curds(curds = c(0.5, 0.3, 0.6),
#'                               recursion_steps = c(32, 6, 2)))
#'
#' # simulate wheyed curdling
#' (wheyed_curdling <- nlm_curds(curds = c(0.5, 0.3, 0.6),
#'                               recursion_steps = c(32, 6, 2),
#'                               wheyes = c(0.1, 0.05, 0.2)))
#' \dontrun{
#' # Visualize the NLMs
#' landscapetools::show_landscape(random_curdling)
#' landscapetools::show_landscape(wheyed_curdling)
#' }
#'
#' @references
#' Keitt TH. 2000. Spectral representation of neutral landscapes.
#' \emph{Landscape Ecology} 15:479-493.
#'
#' Szaro, Robert C., and David W. Johnston, eds. Biodiversity in managed
#' landscapes: theory and practice. \emph{Oxford University Press}, USA, 1996.
#'
#' @aliases nlm_curds
#' @rdname nlm_curds
#'
#' @export

nlm_curds <- function(curds,
                      recursion_steps,
                      wheyes = NULL,
                      resolution = 1) {

  checkmate::assert_numeric(curds)
  if(!is.null(wheyes))checkmate::assert_numeric(wheyes)
  checkmate::assert_integerish(recursion_steps)
  if (length(curds) != length(recursion_steps))
    stop("Length of p and s differs.")
  # maybe recycle percentages
  # convenient if only one is given!?

  # supposed to be faster if initialized with false and inverted in the end
  curd_raster <- raster::raster(matrix(FALSE, 1, 1))

  # convert amount of curds to amount of matrix to follow algorithm logic
  curds <- 1 - curds

  for (i in seq_along(recursion_steps)) {

    # "tile" the raster into smaller subdivisions
    curd_raster <- raster::disaggregate(curd_raster, recursion_steps[i])

    # get tibble with values and ids
    vl     <- raster::values(curd_raster)
    vl_tib <- tibble::as_tibble(vl)
    vl_tib <- tibble::rowid_to_column(vl_tib, "id")

    # 'curdling' select ids randomly which are to be set to true and do so
    vl_tib_curd           <- dplyr::filter(vl_tib, !value)
    vl_tib_curd           <- dplyr::sample_frac(vl_tib_curd, curds[i])
    vl_tib_curd           <- vl_tib_curd$id
    vl_tib$value[vl_tib_curd] <- TRUE

    # 'wheying' select ids randomly which are to be set to false and do so
    if (!is.null(wheyes)) {
      vl_tib_whey           <- dplyr::filter(vl_tib, value)
      vl_tib_whey           <- dplyr::sample_frac(vl_tib_whey, wheyes[i])
      vl_tib_whey           <- vl_tib_whey$id
      vl_tib$value[vl_tib_whey] <- FALSE
    }

    # overwrite rastervalues
    raster::values(curd_raster) <- vl_tib$value
  }

  # invert raster
  raster::values(curd_raster) <- !raster::values(curd_raster)

  # set resolution ----
  raster::extent(curd_raster) <- c(
    0,
    resolution * ncol(curd_raster),
    0,
    resolution * nrow(curd_raster)
  )

  return(curd_raster)
}
