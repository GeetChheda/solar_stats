#' @name install_from_github.R
#' @title Download Package from Github!
#' @author Tim Fraser
#' @description This script shows you how to install your package straight from a public github repository!
#' Note that for your own package, you'll need to put your finalized package on github first.


# Install your package straight from github!
# Try installing mine:
devtools::install_github("timothyfraser/demotool")
library(demotool) # load package 
plus_one(x = 2) # test function

# Now do yours!
# devtools::install_github("yourgithubname/your_repo_name_which_should_be_the_same_as_your_package_name")