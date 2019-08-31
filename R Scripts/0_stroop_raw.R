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
task <- "Stroop"
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
  filter(`Procedure[Trial]` == "StoopTrial" | 
           `Procedure[Trial]` == "stroopPRAC2") %>%
  rename(TrialProc = `Procedure[Trial]`) %>%
  mutate(TrialProc = ifelse(TrialProc == "StoopTrial", "real", "practice"),
         Trial = ifelse(TrialProc == "real", List2.Sample, List5.Sample),
         Condition = ifelse(TrialProc == "real", trialType, pracTYPE),
         Condition = ifelse(Condition == "Cong" | 
                              Condition == "Filler", 
                            "congruent", "incongruent"),
         RT = ifelse(TrialProc == "real", stim.RT, PracStim2.RT),
         Accuracy = ifelse(TrialProc == "real", stim.ACC, PracStim2.ACC),
         Response = ifelse(TrialProc == "real", stim.RESP, PracStim2.RESP),
         Response = ifelse(Response == 1, "GREEN", 
                           ifelse(Response == 2, "BLUE", 
                                  ifelse(Response == 3, "RED", NA))),
         Word = ifelse(TrialProc == "real", word, pracWORD),
         Hue = ifelse(TrialProc == "real", hue, pracHUE)) %>%
  select(Subject, TrialProc, Trial, Condition, RT, Accuracy, Response, 
         Word, Hue, SessionDate, SessionTime)

## Output Data
write_csv(data_raw, path = here(output.dir, output.file))

rm(list=ls())

