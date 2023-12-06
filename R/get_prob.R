#' @name get_prob
#' @title `get_prob()`
#' @description
#' A short description of the function!
#' Can be multiple lines
#' Notice how roxygen commenting always starts with #'
#' For example:
#' This function calculates system reliability over time t given a set of lambdas supplied.
#' @note
#' - `@name` should have no spaces and match the function name.
#' - `@title` is the official title and can be anything.
#' - `@description` is a description that can span multiple lines
#' - `@param` marks each input parameters for your function.
#' - `@export` exports your function to be available to a user of your package. (Eg. not an internal function)
#' - `@importFrom` bundles into your package 1 or more specific functions from another package, so that your package will always function.
#' @param t [integer] time passed. Can be a single integer or a vector of integers.
#' @param lambdas [vector] a vector of failure rates for components, named lambda
#' @param type [character] a single value describing whether these probabilities should be combined using the rules of series or parallel systems.
#'
#' @note You can specify default inputs for an input parameter like with `type = "series"` below.
#' @examples 
#' 
#' # Get series system probability at each time t
#' get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "series")
#' 
#' # Get parallel system probability at each time t
#' get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "parallel")
#' 
#' @note It's important to 'import' any extra functions your package relies on. 
#' You can use `@importFrom`. For example:
#' `@importFrom` packagename function1 function2
#' Note: if you're importing the pipeline from `dplyr`, then you can write it like I do below, where `%>%` is wrapped in ticks, eg.``.
#' 
#' @importFrom tidyr expand_grid
#' @importFrom dplyr `%>%` mutate summarize group_by
#' 
#' @export

get_prob = function(t = 100, lambdas, type = "series"){
  
  # Testing values #########################################
  #    I often store my testing values at the top of the function, 
  #    **commented out**, so I can run them then test the function easily.
  # t = c(100, 200, 300, 400)
  # lambdas = c(0.001, 0.002, 0.01)
  # type = "series"
  
  # Testing packages #######################################
  #    I often list my packages for testing here. 
  #    But be sure to add specific functions to @importFrom
  # library(dplyr)
  # library(tidyr)
  
  # Error handling #####################################
  # If type is not in series or parallel
  if(!type %in% c("series", "parallel")){
    # Stop and provide this error message.
    stop("type must equal 'series' or 'parallel'.")
  }
  
  
  # Get a grid of t and lambdas
  # Numbering your objects can help show progression when developing functions
  grid1 = tidyr::expand_grid(t = t, lambda = lambdas)
  
  grid2 = grid1 %>%
    # For each row,
    dplyr::mutate(
      # Calculate cumulative probability of failure by time t 
      # using exponential distribution, with rate from lambda column
      p_fail = pexp(t, rate = lambda),
      # Then get probability of survival/reliability by time t
      p_reliability = 1 - p_fail)
  
  # If type parameter equals 'series'
  if(type == "series"){
    # Get stats...
    stat = grid2 %>%
      # For each time t
      group_by(t) %>%
      # calculating the product of each component's reliability
      summarize(prob = prod(p_reliability) )
    
    # Or, instead, if type parameter equals 'parallel'
  }else if(type == "parallel"){
    # Get stats...
    stat = grid2 %>%
      # For each time t
      group_by(t) %>%
      # calculating 1 minus the product of each component's chance of failure
      summarize(prob = 1 - prod(p_fail))  
    # Or, if some other value was input...
  }
  
  # I like to always use return(). It's very clear.
  return(stat)
  
}
