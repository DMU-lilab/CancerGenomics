require(data.table)
require(MASS)

#' Calculate AFD frow two sample  allele frequency
#'
#' Calculate Allele Frequency Deviation frow two sample  allele frequency
#'
#' First, the x and y coordinates are transposed at 45 degrees, and the y coordinate after transposition
#' is taken as the deviation of the point. Then absolute deviation I is taken to the power, then multiplied
#' by the density. The density can be achieved by two alternative methods,"xdensity" and "kde2d".
#'
#'
#' @param  FREQ_1.x allele frequency of normal sample to calculate AFD
#' @param  FREQ_1.y allele frequency of tumor sample to calculate AFD
#' @param power d ^ power, d means deviation (abs(transposed y axis))
#' @param density_method method to calculate density, include "xdensity" and "kde2d"
#' @param density logical; if TRUE, use density of bin or each grid to multiply d ^ power
#' @param n integer vector, bins number when calculate density.In "xdensity" method, only one bin number and in kde2d, you can give
#        one (x and y are same) or two
#' @param filterAF numeric, allele frequency cutoff, should between 1 and 100, if allele frequencies of both samples are less than it, then remove these position.
#' @param filterDEV numeric, absolute deviation cutoff, should between 1 and 70, if deviation of a point is less than it, then remove the position.
#' @return AFD value
#' @examples
#' data(afd_test_dt)
#' afd <- AFD(afd_test_dt$FREQ_1.x, afd_test_dt$FREQ_1.y)
#' @export AFD
#' @import data.table
#' @import MASS
AFD <- function(FREQ_1.x, FREQ_1.y, power = 2, density = T, density_method = "xdensity", n = 256, filterAF = 2, filterDEV=5){
  # Calculate AFD frow two sample  allele frequency
  # Args:
  #   REQ_1.x, FREQ_1.y, allele frequency of two sample to calculate AFD
  #   power: d ^ power, d means deviation (abs(transposed y axis))
  #   density: logical; if TRUE, use density of bin or each grid to multiply d ^ power
  #   density_method: method to calculate density, include "xdensity" and "kde2d"
  #   n: integer vector, bins number when calculate density.In "xdensity" method, only one bin number and in kde2d, you can give
  #       one (x and y are same) or two
  #   filterAF: numeric, allele frequency cutoff, should between 1 and 100, if allele frequencies of both samples are less than it, then remove these position.
  #   filterDEV: numeric, absolute deviation cutoff, should between 1 and 70, if deviation of a point is less than it, then remove the position.
  # Returns: AFD value
  require(data.table)

  get_density_2d <- function(x, y, n=101){
    # Get gensity of two dimention
    # Args:
    #    x: x axis data, should be transposed by transpose_coordinate function
    #    y: y axis data, should be transposed by transpose_coordinate function
    # Returns: kde 2d result
    min_x <- 0
    max_x <- 100/cos(pi/4)
    min_y <- 100*sin(-pi/4)
    max_y <- -min_y

    kde_lst<- kde2d(x,y, n=n, lims = c(min_x, max_x , min_y, max_y))
    return(kde_lst)
  }


  transpose_coordinate <- function(x, y){
    # Transpose the coordinate of two sample allele freqency, it will rotate for pi/4
    # Args:
    #    x, y: x and y are the vectors of coordinates for x and y axis
    # Returns: the rotated coordinates of x and y
    x1 <- x*cos(-pi/4) - y*sin(-pi/4)
    y1 <- x*sin(-pi/4) + y*cos(-pi/4)
    return(data.table(diagonal=x1,deviation=y1))
  }

  # filter allele frequency
  filter_idx <- !(FREQ_1.x < filterAF &  FREQ_1.y < filterAF)
  FREQ_1.x <- FREQ_1.x[filter_idx]
  FREQ_1.y <- FREQ_1.y[filter_idx]

  dt <- transpose_coordinate(FREQ_1.x, FREQ_1.y) # corrdinate transpose
  dt <- dt[abs(deviation) >= filterDEV,] # filter by deviation
  ## AFD when density is not taken into count
  if(!density){return(mean(abs(dt$deviation)^power))}
  ## AFD when using "xdensity" method, i.e., the transposed diagonal
  if(density_method == "xdensity"){
    dn <- density(dt$diagonal, n=n) #1d Kernal Density
    bin_len <- dn$x[2] - dn$x[1] # bin length
    breaks <- c(dn$x - bin_len/2, dn$x[length(dn$x)] + bin_len/2) # bin boundary, treat dn$x as bin center point
    dt$bin_idx <- cut(dt$diagonal, breaks = breaks, labels = F) # add bin id to dt data.table
    dt$density <- dn$y[dt$bin_idx] # add density of each bin to dt data.table
    #bin_dt <- unique(dt[,.(d=mean(abs(deviation)), density),by = bin_idx])
    #AFD <- mean((abs(bin_dt$d)) ^ power * bin_dt$density)
    bin_dt <- dt[, .(bin_AFD=mean(abs(deviation)) ^ power * mean(density)), by=bin_idx]
    AFD <- mean(bin_dt$bin_AFD)
  }else if(density_method =="kde2d"){
    density_2d <- get_density_2d(dt$diagonal, dt$deviation, n = n)
    density <- density_2d$z # rows for diagonal, i.e. x, bins, column for deviation, i.e. y,  bins
    deviation <- density_2d$y
    AFD <- mean(density %*% abs(deviation) ^ power) # calculate AFD by matrix multiplication
  }
  return(AFD)
}



