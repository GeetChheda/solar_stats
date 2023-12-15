# Load functions straight from file
source("R/generate_stats_plots.R")


# Or use load_all() from devtools to load them as if they were a package
# devtools::load_all(".")

# Testing of functions

solardata1 = generate_stats_plot("z/station00.csv",
                                "date_time", "power", spec = 1.297, 
                                "Weeks (Subgroups)", "Average Power (KWh)",
                                "Variation of Average Power against Time")


## This below fucntion should show an error as the input spec is missing
solardata2 = generate_stats_plot("z/station00.csv",
                                "date_time", "power",
                                "Weeks (Subgroups)", "Average Power (KWh)",
                                "Variation of Average Power against Time")


# Always a good idea to clear your environment and cache
rm(list = ls()); gc()
