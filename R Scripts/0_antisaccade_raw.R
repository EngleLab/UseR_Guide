## Set up ####
## Load packages
library(readr)
library(here)
library(englelab)

## Set import/output directories
import_dir <- "Data Files/Raw Data/Merged"
output_dir <- "Data Files/Raw Data"

## Set import/output files
task <- "Antisaccade"
import_file <- paste(task, ".txt", sep = "")
output_file <- paste(task, "_raw.csv", sep = "")
##############

## Import Data
data_import <- read_delim(here(import_dir, import_file), "\t",
                          escape_double = FALSE, trim_ws = TRUE,
                          guess_max = 10000)

## Clean up raw data
data_raw <- raw_antisaccade(data_import, taskVersion = "old")

## Save Data
write_csv(data_raw, path = here(output_dir, output_file))

rm(list=ls())
