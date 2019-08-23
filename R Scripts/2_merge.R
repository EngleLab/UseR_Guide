## Set up ####
## Load packages
library(here)
library(readr)
library(dplyr)
library(datawrangling)

## Set import/output directories
directories <- readRDS(here("directories.rds"))
import.dir <- directories$scored
output.dir <- directories$data
##############

## Import Files
import <- files_join(here(import.dir), 
                     pattern = "Scores", id = "Subject")

## Select only important variables and remove outliers
data_merge<- import %>%
  select() %>%
  trim(variables = "all", cutoff = 3.5, id = "Subject")

## Create list of final subjects 
subj.list <- select(data_merge, Subject)

## Save
write_csv(data_merge, here(output.dir, "name_of_datafile.csv"))
write_csv(subj.list, here(output.dir, "subjlist_final.csv"))

rm(list=ls())
