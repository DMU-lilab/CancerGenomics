require(data.table)

#' Create an argument table
#'
#' Create an argument table
#'
#' Give arguents to create an argument table including all possible combinations
#'
#'
#' @param  ... all arguments of AFD function to test
#' @return data table: all possible combinations of n arguments
#' @examples
#' arg_table <- create_argtable(power = seq(1, 5, by = 1), density = c(T,F),
#' density_method = c("xdensity", "kde2d"), n = 2^(7:9),filterAF = seq(1, 5, by = 1), filterDEV = seq(1,20, by = 5))
#' @export create_argtable
#' @import data.table
create_argtable <- function(...){
  # Create an argument table
  # Args:
  #   all arguments of AFD function to test
  # Returns: data table: all possible combinations of n arguments
  args <- list(...)
  add <- function(a, b){
    # Args:
    #      a: vector; all test arguments of arg 1
    #      b: vector: all test arguments of arg 2
    # Return: all possible combinations of args1 and args 2
    return(sapply(a, function(x){sapply(b, function(y){paste(x, y, sep = ",")})}))
  }

  arg_table_fun <- function(n){
    # Args:
    #     n: integer; total arguments to add
    # Returns: vector; all possible combinations of n arguments, from arg n to arg 1
    if(n ==1){return(args[[n]])
    }else{
      return(add(args[n], arg_table_fun(n-1)))
    }
  }

  change_type <- function(x, need_type){
    # Args:
    #     x: vector, data to transform
    #     need_type, type need to transform
    # Returns: data which data type are right
    if(need_type == "logical"){
      return(as.logical(x))
    }else if(need_type == "numeric"){
      return(as.numeric(x))
    }else if(need_type == "factor"){
      return(as.factor(x))
    }else if(need_type == "character"){
      return(x)
    }
  }

  arg_vector <- arg_table_fun(length(args))
  arg_table <- as.data.table(tstrsplit(arg_vector, split = ","))
  arg_table <- arg_table[,ncol(arg_table):1]
  colnames(arg_table) <- names(args)

  setDF(arg_table)
  for(i in 1:ncol(arg_table)){
    arg_table[,i] <- change_type(arg_table[,i], class(args[[i]]))
  }
  setDT(arg_table)
  return(arg_table)
}
