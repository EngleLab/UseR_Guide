## Set up ####
## Load packages
library(here)
library(readr)
library(dplyr)
library(datawrangling)

## Set Import/Output Directories
directories <- readRDS(here("directories.rds"))
import.dir <- directories$messy
output.dir <- directories$raw

## Set Import/Output Filenames
task <- "taskname"
import.file <- paste(task, ".txt", sep = "")
output.file <- paste(task, "raw.csv", sep = "_")
##############

## Import ####
import <- read_delim(here(import.dir, import.file), 
                     "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  duplicates_remove(taskname = task, 
                    output.folder = here(output.dir, "duplicates"))
##############

## Tidy raw data ####
data_raw <- import %>%
  filter() %>%
  rename() %>%
  mutate() %>%
  select()
#####################

## Output ####
write_csv(data_raw, here(output.dir, output.file))
##############

rm(list=ls())

