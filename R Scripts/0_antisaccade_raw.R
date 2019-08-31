## Set up ####
## Load packages
library(readr)
library(dplyr)
library(here)
library(datawrangling)

## Set import/output directories
import.dir <- "Data Files/Merged"
output.dir <- "Data Files"

## Set import/output files
task <- "Antisaccade"
import.file <- paste(task, ".txt", sep = "")
output.file <- paste(task, "_raw.csv", sep = "")
##############

## Import Data
data_import <- read_delim(here(import.dir, import.file),
                          "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  duplicates_remove(taskname = task,
                    output.folder = here(output.dir, "duplicates"))

## Clean up raw data and save
data_raw <- data_import %>%
  filter(`Procedure[Trial]` == "TrialProc" |
           `Procedure[Trial]` == "pracproc") %>%
  group_by(Subject) %>%
  mutate(TrialProc = case_when(`Procedure[Trial]` == "TrialProc" ~ "real",
                               `Procedure[Trial]` == "pracproc" ~ "practice"),
         Trial = case_when(TrialProc == "real" ~ TrialList.Sample,
                           TrialProc == "practice" ~ practice.Sample),
         Target = case_when(!is.na(right_targ) ~ right_targ,
                            !is.na(left_targ) ~ left_targ)) %>%
  select(Subject, TrialProc, Trial, Accuracy = masks.ACC, RT = masks.RT, Target,
         FixationDuration = t4, SessionDate, SessionTime)

## Output Data
write_csv(data_raw, path = here(output.dir, output.file))

rm(list=ls())