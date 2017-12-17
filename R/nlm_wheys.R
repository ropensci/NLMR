#' nlm_wheys
#'
#' @description Simulates a wheyed neutral landscape model.
#'
#' @details Wheyed landscape models builts on landscapes derived from random
#' curdling (\code{nlm_curds()}), by adding "wheye" on the "curds". Wheye is
#' hereby an additional step after the first recursion, where previously
#' selected cells that were declared matrix (value == FALSE) are now considered
#' to contain a proportion (\code{q}) of habitat.
#'
#' If \deqn{p_{1} = p_{2} = q_{2} = ... = p_{n} = p_{n}} the models resembles
#' a binary random map.
#'
#' @param p [\code{numerical(x)}]\cr
#' Vector with percentage(s) to fill with curds (fill with Habitat (value ==
#' TRUE)).
#' @param s [\code{numerical(x)}]\cr
#' Vector of successive cutting steps for the blocks (split 1 block into x
#' blocks).
#' @param q [\code{numerical(x)}]\cr
#' Vector of with percentage(s) to fill with wheys (fill with Habitat (value ==
#' TRUE)).
#' @param ext [\code{numerical(1)}]\cr
#' Extent of the resulting raster (0,x,0,x).
#'
#' @return raster
#'
#' @examples
#' nlm_wheys(c(0.1, 0.3, 0.6), c(32, 6, 2), c(0.1, 0.05, 0.2))
#'
#' @seealso \code{\link{nlm_curds}}
#'
#' @references
#' Szaro, Robert C., and David W. Johnston, eds. Biodiversity in managed
#' landscapes: theory and practice. \emph{Oxford University Press}, USA, 1996.
#'
#' @aliases nlm_wheys
#' @rdname nlm_wheys
#'
#' @importFrom magrittr "%>%"
#'
#' @export
#'

nlm_wheys <- function(p,
                      s,
                      q,
                      ext = 1) {

  # supposed to be faster if initialized with false and inverted in the end
  wheye_raster <- raster::raster(matrix(FALSE, 1, 1))

  #
  p <- 1 - p

  for (i in seq_along(s)) {

    # "tile" the raster into smaller subdivisions
    wheye_raster <- raster::disaggregate(wheye_raster, s[i])

    # get tibble with values and ids
    vl <- raster::values(wheye_raster) %>%
      tibble::as_tibble() %>%
      dplyr::mutate(id = seq_len(raster::ncell(wheye_raster)))

    # select ids randomly which are set to true and do so
    ids <- vl %>%
      dplyr::filter(!value) %>%
      dplyr::sample_frac(p[i]) %>%
      .$id
    vl$value[ids] <- TRUE

    # overwrite rastervalues
    raster::values(wheye_raster) <- vl$value

    # add wheye by proceding
    vl <- raster::values(wheye_raster) %>%
      tibble::as_tibble() %>%
      dplyr::mutate(id = seq_len(raster::ncell(wheye_raster)))

    # select ids randomly which are set to true and do so
    ids <- vl %>%
      dplyr::filter(value) %>%
      dplyr::sample_frac(q[i]) %>%
      .$id
    vl$value[ids] <- FALSE

    # overwrite rastervalues
    raster::values(wheye_raster) <- vl$value
  }

  # invert raster
  raster::values(wheye_raster) <- !raster::values(wheye_raster)

  # set resolution ----
  raster::extent(wheye_raster) <- c(
    0,
    ext,
    0,
    ext
  )

  return(wheye_raster)
}
