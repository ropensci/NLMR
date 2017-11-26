#' nlm_curds
#'
#' @description desc.
#'
#' @details detail.
#'
#' @param p [\code{numerical(x)}]\cr
#' Vector with percentage(s) to cut of (fill with zeroes)
#' @param s [\code{numerical(x)}]\cr
#' Vector of successive cutting steps (split 1 cell into x cells)
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#'
#' @return raster
#'
#' @examples
#' nlm_curds(c(0.25, 0.25, 0.5), c(64, 8, 1))
#'
#' @aliases nlm_curds
#' @rdname nlm_curds
#'
#' @importFrom magrittr "%>%"
#'
#' @export
#'

nlm_curds <- function(p,
                      s,
                      resolution = 1) {

  # check for same lenght of p and s

  curd_raster <- raster::raster(matrix(1, 1, 1))

  for (i in seq_along(s)) {

    # "tile" the raster into smaller subdivisions
    curd_raster <- raster::disaggregate(curd_raster, s[i])

    # get tibble with values and ids
    vl <- raster::values(curd_raster) %>%
          tibble::as_tibble() %>%
          dplyr::mutate(id = seq_len(raster::ncell(curd_raster)))

    # select ids randomly which are set to 0 and do so
    ids <- vl %>%
           dplyr::filter(value > 0) %>%
           dplyr::sample_frac(p[i]) %>%
           .$id
    vl$value[ids] <- 0

    # overwrite rastervalues
    raster::values(curd_raster) <- vl$value
  }

  # set resolution ----
  raster::extent(curd_raster) <- c(0,
                                          ncol(curd_raster)*resolution,
                                          0,
                                          nrow(curd_raster)*resolution)


  return(curd_raster)
}
