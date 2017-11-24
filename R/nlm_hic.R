#' hierachical curdling
#'
#' @description desc.
#'
#' @details detail.
#'
#' @param perc percentage to cut of (zeroes)
#'
#' @param depth recursion depth
#'
#'
#' @return raster
#'
#' @examples
#' neutrMap <- nlm_hic(0.2, 5)
#'
#' @aliases nlm_hic
#' @rdname nlm_hic
#'
#' @export
#'

nlm_hic <- function(p, d) {

  mp <- raster::raster(matrix(1, 2, 2))

  for (i in seq_len(d)) {
    mp <- raster::disaggregate(mp, 2)

    vl <- values(mp) %>% as_tibble() %>% mutate(id = seq_len(ncell(mp)))
    ids <- vl %>% filter(value > 0) %>% sample_frac(p) %>% .$id
    vl$value[ids] <- 0

    values(mp) <- vl$value
  }
  mp
}
