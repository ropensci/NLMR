# Returns a random displacement between -0.5 * disheight and 0.5 * disheight

.randomdisplace <- function(disheight){

  # Returns a random displacement between -0.5 * disheight and 0.5 * disheight
  displacement <- stats::runif(1,0,1) * (disheight - 0.5) * disheight
  return(displacement)
}

# Calculate the average value of the 4 corners of a square (3 if up
# against a corner) and displace at random.
.displacevals <- function(p, disheight){

  if (length(p) == 4){
    pcentre = 0.25 * sum(p) + .randomdisplace(disheight)
  } else{
    pcentre = sum(p) / 3 + .randomdisplace(disheight)
  }
  return(pcentre)

}

# Get the coordinates of the diamond centred on diax, diay with radius i2
# if it fits inside the study area

.check_diamond_coords <- function(diax,diay,dim,i2){
  if (diax < 0 | diax > dim | diay < 0 | diay > dim) {
    return(NULL)
  } else if (diax-i2 < 0){
    coords <- list(c(diax+i2,diay),c(diax,diay-i2),c(diax,diay+i2))
    return(lapply(coords, as.integer))
  } else if (diax + i2 >= dim){
    coords <- list(c(diax-i2,diay),c(diax,diay-i2),c(diax,diay+i2))
    return(lapply(coords, as.integer))
  } else if (diay-i2 < 0){
    coords <- list(c(diax+i2,diay),c(diax- i2,diay),c(diax,diay+ i2))
    return(lapply(coords, as.integer))
  } else if (diay+i2 >= dim) {
    coords <- list(c(diax+i2,diay),c(diax-i2,diay),c(diax,diay-i2))
    return(lapply(coords, as.integer))
  } else {
    coords <- list(c(diax+i2,diay),c(diax-i2,diay),c(diax,diay-i2),c(diax,diay+i2))
    return(lapply(coords, as.integer))
  }
}


#' Method mpdNLM
#' @name mpdNLM-method
#' @rdname mpdNLM-method
#' @exportMethod mpdNLM

setGeneric("mpdNLM", function(nCol, nRow, h, rescale = TRUE) {
  standardGeneric("mpdNLM")
})


#' mpdNLM
#'
#' Create a midpoint displacement neutral landscape model with values ranging 0-1.
#'
#' @param nCol Number of columns for the raster (numerical)
#' @param nRow Number of rows for the raster (numerical)
#' @param h The h value controls the level of spatial autocorrelation in element values.
#' @param rescale If \code{TRUE} (Standard), the values are rescaled between 0-1. Otherwise, the distance in raster units is calculated (logical)
#'
#' @return Raster with random values ranging from 0-1.
#'
#'
#' @examples
#' \dontrun{
#' mpdNLM(nCol = 100, nRow = 100, h = 0.2)
#' }
#'
#' @aliases mpdNLM
#' @rdname mpdNLM-method
#'
#' @export
#'

setMethod(
  "mpdNLM",
  definition = function(nCol, nRow, h, rescale = TRUE) {

    # Check Function arguments
    Check <- ArgumentCheck::newArgCheck()

    if (nCol < 1)
      ArgumentCheck::addError(
        msg = "'nCol' must be >= 1",
        argcheck = Check
      )

    if (nRow < 1)
      ArgumentCheck::addError(
        msg = "'nRow' must be >= 1",
        argcheck = Check
      )

    if (missing(h) || h > 0 || h < 1) {
      ArgumentCheck::addWarning(
        msg = "'h' must be between 0 and 1. Value has been set to 0.5",
        argcheck = Check
      )
      h <- 0.5
    }

    if (!is.logical(rescale)){
      ArgumentCheck::addWarning(
        msg = "'rescale' must be logical. Value has be set to TRUE",
        argcheck = Check
      )
      rescale <- TRUE
    }
    # Return errors and warnings (if any)
    ArgumentCheck::finishArgCheck(Check)

    # Determine the dimension of the smallest square
    maxDim <-  max(nRow, nCol)
    N      <- as.integer(ceiling(log(maxDim - 1, 2)))
    dim    <-  2 ** N + 1

    # Create a surface consisting of random displacement heights average value
    # 0, range from [-0.5, 0.5] x displacementheight
    disheight <-  2.0
    surface <- matrix(stats::runif(dim * dim,0,1),dim,dim) * disheight - 0.5 * disheight

    # Set square size to cover the whole array
    inc <-  dim - 1
    while (inc > 1) {
      # while considering a square/diamond at least 2x2 in size

      i2 = inc / 2 # what is half the width (i.e. where is the centre?)
      # SQUARE step
      for (x in seq(1, dim - 1, inc)) {
        for (y in seq(1, dim - 1, inc)) {
          # this adjusts the centre of the square
          surface[x + i2, y + i2]  <-
            .displacevals(c(surface[x, y], surface[x + inc, y], surface[x + inc, y + inc], surface[x, y + inc]), disheight)
        }
      }
      # DIAMOND step
      for (x in seq(0, dim - 2, inc)) {
        for (y in seq(0, dim - 2, inc)){

          #
          diaco <- .check_diamond_coords(x+i2,y,dim,i2)
          diavals <- numeric()

          for (co in diaco){
            coord_temp <- surface[ifelse(co[1] == 0, 1, co[1]), ifelse(co[2] == 0, 1, co[2])]
            diavals <- append(diavals, coord_temp)
          }

          surface[x+i2,y] <- .displacevals(diavals,disheight)

          #
          diaco <- .check_diamond_coords(x,y+i2,dim,i2)
          diavals <- numeric()
          for (co in diaco){
            coord_temp <- surface[ifelse(co[1] == 0, 1, co[1]), ifelse(co[2] == 0, 1, co[2])]
            diavals <- append(diavals, coord_temp)
          }

          surface[x,y+i2] <- .displacevals(diavals,disheight)

          #
          diaco <- .check_diamond_coords(x+inc,y+i2,dim,i2)
          diavals <- numeric()
          for (co in diaco){
            coord_temp <- surface[ifelse(co[1] == 0, 1, co[1]), ifelse(co[2] == 0, 1, co[2])]
            diavals <- append(diavals, coord_temp)
          }
          surface[x+inc,y+i2]  <- .displacevals(diavals,disheight)

          #
          diaco   <- .check_diamond_coords(x+i2,y+inc,dim,i2)
          diavals <- numeric()
          for (co in diaco){
            coord_temp <- surface[ifelse(co[1] == 0, 1, co[1]), ifelse(co[2] == 0, 1, co[2])]
            diavals <- append(diavals, coord_temp)
          }
          surface[x+i2,y+inc]  <- .displacevals(diavals,disheight)
        }
      }
      # Reduce displacement height
      disheight = disheight * 2 ** (-h)
      inc = inc / 2
    }

    mpd_Raster <- raster::raster(surface)

    # Rescale values to 0-1
    if (rescale == TRUE) {
      mpd_Raster <- rescaleNLM(mpd_Raster)
    }

    return(mpd_Raster)

  }
)
