#' nlm_randomcluster
#'
#' Simulates a random cluster nearest-neighbour neutral landscape.
#'
#' @param ncol [\code{integer(1)}]\cr
#' Number of columns forming the raster.
#' @param nrow  [\code{integer(1)}]\cr
#' Number of rows forming the raster.
#' @param resolution  [\code{numerical(1)}]\cr
#' Resolution of the raster.
#' @param neighbourhood [\code{numerical(1)}]\cr
#' Clusters are defined using a set of neighbourhood structures,
#'  4 (Rook's or von Neumann neighbourhood) (default), 8 (Queen's or Moore neighbourhood).
#' @param p [\code{numerical(1)}]\cr
#' Defines the proportion of elements randomly selected to form
#' clusters.
#' @param ai Vector with the cluster type distribution (percentages of occupancy).
#' This directly controls the number of types via the given length.
#' @param rescale [\code{logical(1)}]\cr
#' If \code{TRUE} (default), the values are rescaled between 0-1.
#' @param crs [\code{character(1)}]\cr
#' The crs for the new raster. If blank, defaults to WGS 84.
#'
#' @return SpatRaster with random values ranging from 0-1.
#'
#' @details
#' This is a direct implementation of steps A - D of the modified random clusters algorithm
#' by Saura & Martínez-Millán (2000), which creates naturalistic patchy patterns.
#'
#'
#' @examples
#' # simulate random clustering
#' random_cluster <- nlm_randomcluster(ncol = 30, nrow = 30,
#'                                      p = 0.4,
#'                                      ai = c(0.25, 0.25, 0.5))
#' \dontrun{
#' # visualize the NLM
#' landscapetools::show_landscape(random_cluster)
#' }
#'
#' @references
#' Saura, S. & Martínez-Millán, J. (2000) Landscape patterns simulation with a
#' modified random clusters method. \emph{Landscape Ecology}, 15, 661 – 678.
#'
#' @aliases nlm_randomcluster
#' @rdname nlm_randomcluster
#'
#' @export
#'


nlm_randomcluster <- function(ncol, nrow,
                              resolution = 1,
                              p,
                              ai = c(0.5, 0.5),
                              neighbourhood = 4,
                              rescale = TRUE, 
                              crs = "+proj=merc +lon_0=0 +k=1 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs") {

  # Check function arguments ----
  checkmate::assert_count(ncol, positive = TRUE)
  checkmate::assert_count(nrow, positive = TRUE)
  checkmate::assert_numeric(resolution)
  checkmate::assert_numeric(p)
  checkmate::assert_true(p <= 1)
  checkmate::assert_numeric(ai)
  checkmate::assert_true(neighbourhood == 4 || neighbourhood == 8)
  checkmate::assert_logical(rescale)

  # Step A - Create percolation map
  ranclumap <- nlm_percolation(ncol, nrow, p, resolution = resolution, crs = crs)

  # Step B - Cluster identification (clustering of adjoining pixels)
  ranclumap <- terra::patches(x = ranclumap, directions = neighbourhood, zeroAsNA = T)
  #terra::values(ranclumap)[is.na(terra::values(ranclumap))] <- 0
  
  # Step C - Cluster type assignation
  # number of different cluster
  numclu <- length(unique(ranclumap[][!is.na(ranclumap[])]))
  # assign to each cluster nr a new category given by Ai
  clutyp <- sample(seq_along(ai), numclu, replace = TRUE, prob = ai)
  # write back new category nr
  class_df <- data.frame('is' = unique(ranclumap[][!is.na(ranclumap[])]),
                         'becomes' = clutyp)
  ranclumap <- terra::classify(ranclumap, rcl = class_df, include.lowest=T)

  # Step D - Filling the map
  # helperfuction to choose values
  fillit <- function(cid) {
    # get neighbour cells
    nbrs <- terra::adjacent(ranclumap, cid, directions = 8, pairs = FALSE)
    # count neighbour values (exclude NA see Saura 2000 paper)
    vals <- table(terra::values(ranclumap)[nbrs])
    # check if everything is NA
    if (!length(vals)) {
      # be a rebel get your own value
      fili <- sample(seq_along(ai), 1, prob = ai)
    }else{
      # if there is a majority be an prick and join the winning team
      fili <- as.integer(names(vals)[vals == max(vals)])
      if (length(fili) > 1) {
        # if there is a tie just join a faction
        fili <- sample(fili, 1)
      }
    }
    # choose your destiny
    return(fili)
  }

  # identify unfilled cells
  gaps <- dplyr::rowwise(tibble::tibble(
    ctf = (1:(ncol * nrow))[is.na(terra::values(ranclumap))]
    ))
  # get values for the gaps
  gaps <- dplyr::mutate(gaps, val = fillit(ctf))
  # feed it back in the map
  terra::values(ranclumap)[gaps$ctf] <- gaps$val

  # specify resolution ----
  # raster::extent(ranclumap) <- c(
  #   0,
  #   ncol(ranclumap) * resolution,
  #   0,
  #   nrow(ranclumap) * resolution
  # )

  # Rescale values to 0-1 ----
  if (rescale == TRUE) {
    ranclumap <- ranclumap / max(ranclumap[])
  }

  return(ranclumap)
}
