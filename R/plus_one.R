#' @name plus_one
#' @title Plus One
#' @description Function to add 1 to a numeric input vector.
#' @author Tim Fraser, PhD
#' @param x (numeric) vector of 1 or more numeric values.
#' @note Adding `@export` below means this function will become accessible by package users, rather than being an internal-only function.
#' @export
plus_one = function(x){
  output = x + 1
  return(output)
} 
