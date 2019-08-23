## Setup ####
## Load Packages
library(here)

## Specify the directory tree
directories <- list(scripts = "R Scripts",
                    raw = "Data Files",
                    messy = "Data Files/E-Merge")

saveRDS(directories, here("directories.rds"))
#############

#############################################
#------ 0. "messy" to "tidy" raw data ------# 
#############################################

source(here("R Scripts", "0_task_raw.R"), echo=TRUE)

#############################################

rm(list=ls())
