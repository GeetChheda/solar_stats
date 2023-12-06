#' @name workflow.R
#' @title Example Workflow for `demotool` package functions
#' @author Tim Fraser, your names here...
#' @description Script for test workflow of `demotool` package functions.


# Load functions straight from file
source("R/plus_one.R")
source("R/get_prob.R")

# Or use load_all() from devtools to load them as if they were a package
# devtools::load_all(".")

plus_one(x = 1)
get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "series")


# Test out making new functions
plus_n = function(x, n){ x + n }

plus_n(x = c(1,2,3), n = 2)

# When you're happy with a function, go put it in an R script in the /R folder.


# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
