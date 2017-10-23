#' metric_area
#'
#' @description Classify a matrix with values ranging 0-1 into proportions based upon a vector of class weightings.
#'
#' @details  The length of the weighting vector determines the number of classes in the resulting matrix.
#'
#' @param nlm [\code{matrix(x,y)}]\cr 2D matrix of data values.
#' @param poi [\code{numerical}]\cr  Vector of numeric values.
#'
#' @return Rectangular matrix reclassified values.
#'
#' @aliases metric_area
#' @rdname metric_area
#'
#' @export
#'

metric_area <- function(nlm, poi = NULL){


  if(is.null(poi)){
    poi <- sort(unique(nlm@data@values))
  }

  freq_tib <- dplyr::tbl_df(raster::freq(nlm))

  if(length(poi) == 1){
    area_poi      <- freq_tib[freq_tib == poi,2]
    area_poi_perc <- area_poi / raster::ncell(nlm)
  } else {
    area_poi      <- freq_tib[freq_tib == poi,2]
    area_poi_perc <- dplyr::tbl_df(area_poi / raster::ncell(nlm))
  }

  area_poi$class <- poi
  area_poi_perc$class <- poi

  return(list(Total_Area = area_poi, Percentage_Area = area_poi_perc))
}

