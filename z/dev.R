#' @name dev.R
#' @title Tool to implement Statistical Process Control & understand impact of external factors on Solar Power Output
#' @author Geet Chheda, Sagar Shenoy, Animesh Chaturvedi, Ishwari Joshi, Shikhar Singh
#' @description Script for test package building of `solarstats` package functions.

# Unload your package and uninstall it first.
unloadNamespace("solarstats"); remove.packages("solarstats")
# Auto-document your package, turning roxygen comments into manuals in the `/man` folder
devtools::document(".")
# Load your package temporarily!
devtools::load_all(".")

# Test out our functions

# Get parallel system probability at each time t
solarstats::generate_stats_plot("z/station00.csv","date_time", "power", spec = 1.297, 
                                 "Weeks (Subgroups)", "Average Power (KWh)","Variation of Average Power against Time")

# When finished, remember to unload the package
unloadNamespace("solarstats"); remove.packages("solarstats")

# Then, when ready, document, unload, build, and install the package!
# For speedy build, use binary = FALSE and vignettes = FALSE
devtools::document(".");
unloadNamespace("solarstats");
devtools::build(pkg = ".", path = getwd(), binary = FALSE, vignettes = FALSE)


# Install your package from a local build file
# such as 
# install.packages("nameofyourpackagefile.tar.gz", type = "source")
# or in our case:
install.packages("solarstats_0.1.0.tar.gz", type = "source")

# Load your package!
library("solarstats")

solarstats::generate_stats_plot("z/station00.csv","date_time", "power", spec = 1.297, 
                                "Weeks (Subgroups)", "Average Power (KWh)","Variation of Average Power against Time")


# When finished, remember to unload the package
unloadNamespace("solarstats"); remove.packages("solarstats")

# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
