require(data.table)

#' Get afd value in all possible arguments of AFD function
#'
#' Get afd value in all possible arguments of AFD function
#'
#' Get afd value in all possible arguments of AFD function
#'
#'
#' @param  FREQ_1.x allele frequency of normal sample to calculate AFD
#' @param  FREQ_1.y allele frequency of tumor sample to calculate AFD
#' @return data.table, all AFD value in all possible combinations of n arguments
#' @examples
#' data(afd_test_dt)
#' afd <- test_afd(afd_test_dt$FREQ_1.x, afd_test_dt$FREQ_1.y)
#' @export test_afd
#' @import data.table
test_afd <- function(FREQ_1.x, FREQ_1.y){
  # Get afd value in all possible arguments
  # Args:
  #   REQ_1.x, FREQ_1.y, allele frequency of two sample to calculate AFD
  # Returns: data.table, all AFD value in all possible combinations of n arguments
  arg_table <- create_argtable(power = seq(1, 5, by = 1), density = c(T), density_method = c("xdensity", "kde2d"), n = 2^(7:9),filterAF = seq(0, 1, by = 0.1), filterDEV = seq(1,20, by = 5))
  arg_table_no_density <- create_argtable(power = seq(1, 5, by = 1), density = c(F), density_method ="xdensity", n = 256,filterAF = seq(1, 5, by = 1),filterDEV = seq(1,20, by = 5))
  arg_table <- rbind(arg_table, arg_table_no_density)
  arg_table[,AFD:=AFD(FREQ_1.x = FREQ_1.x, FREQ_1.y = FREQ_1.y, power = power, density = density, density_method = density_method,
                      n = n, filterAF = filterAF, filterDEV = filterDEV),by=.(power, density, density_method, n, filterAF, filterDEV)]
  return(arg_table)
}
