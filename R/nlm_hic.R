#' hierachical curdling
#'
#' @description desc.
#'
#' @details detail.
#'
#'
#' @param perc vector with percentage(s) to cut of (fill with zeroes)
#'
#' @param splits vector of successive cutting steps (split 1 cell into x cells)
#'
#'
#' @return raster
#'
#' @examples
#' neutrMap <- nlm_hic(c(0.25, 0.25, 0.5), c(64, 8, 1))
#'
#' @aliases nlm_hic
#' @rdname nlm_hic
#'
#' @export
#'

nlm_hic <- function(p, s) {

  # check for same lenght of p and s

  mp <- raster::raster(matrix(1, 1, 1))

  for (i in seq_along(s)) {
    mp <- raster::disaggregate(mp, s[i])

    vl <- values(mp) %>% as_tibble() %>% mutate(id = seq_len(ncell(mp)))
    ids <- vl %>% filter(value > 0) %>% sample_frac(p[i]) %>% .$id
    vl$value[ids] <- 0

    values(mp) <- vl$value
  }
  mp
}
