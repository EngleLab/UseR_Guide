## Setup ####
## Load Packages
library(here)
library(readr)
library(dplyr)

## Set Import/Output Directories
directories <- readRDS(here("directories.rds"))
import.dir <- directories$raw
output.dir <- directories$scored

## Set Import/Output Filenames
task <- "taskname"
import.file <- paste(task, "raw.csv", sep = "_")
output.file <- paste(task, "Scores.csv", sep = "_")

## Set Data Cleaning Params 

#############

## Import ####
import <- read_csv(here(import.dir, import.file))
##############

## Data Cleaning and Scoring ####
data <- import %>%
  filter() %>%
  group_by() %>%
  summarise()
#################################

## Output ####
write_csv(data, here(output.dir, output.file))
##############

rm(list=ls())

