#' @name dev.R
#' @title Example Development Script for building and checking `demotool` package functions
#' @author Tim Fraser, your names here...
#' @description Script for test package building of `demotool` package functions.

# Unload your package and uninstall it first.
unloadNamespace("solar_stats"); remove.packages("solar_stats")
# Auto-document your package, turning roxygen comments into manuals in the `/man` folder
devtools::document(".")
# Load your package temporarily!
devtools::load_all(".")

# Test out our functions

# Add 1 to x
solar_stats::plus_one(x = 1)
# Add 1 to a vector of x values
solar_stats::plus_one(x = c(1,2,3,4))

# Get series system probability at each time t
solar_stats::get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "series")
 
# Get parallel system probability at each time t
solar_stats::get_prob(t = c(2,4,5,6), lambdas = c(0.001, 0.02), type = "parallel")

# Just think: you could make many functions,
# outputting vectors, data.frames, ggplot visuals, etc.
# So many options!

# When finished, remember to unload the package
unloadNamespace("solar_stats"); remove.packages("solar_stats")

# Then, when ready, document, unload, build, and install the package!
# For speedy build, use binary = FALSE and vignettes = FALSE
devtools::document(".");
unloadNamespace("solar_stats");
devtools::build(pkg = ".", path = getwd(), binary = FALSE, vignettes = FALSE)


# Install your package from a local build file
# such as 
# install.packages("nameofyourpackagefile.tar.gz", type = "source")
# or in our case:
install.packages("solar_stats_0.1.0.tar.gz", type = "source")

# Load your package!
library("solar_stats")


# When finished, remember to unload the package
unloadNamespace("solar_stats"); remove.packages("solar_stats")

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
