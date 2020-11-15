#### Set up ####
## Load packages
library(here)
library(readr)
library(dplyr)
library(datawrangling)

## Set Import/Output Directories
import_dir <- "Data Files/Merged"
output_dir <- "Data Files"

## Set Import/Output Filenames
task <- "Flanker"
import_file <- paste(task, ".txt", sep = "")
output_file <- paste(task, "raw.csv", sep = "_")
################

#### Import ####
import <- read_delim(here(import_dir, import_file),
                     "\t", escape_double = FALSE, trim_ws = TRUE) %>%
  duplicates_remove(taskname = task,
                    output.folder = here(output.dir, "duplicates"))
################

#### Tidy raw data ####
data_raw <- import %>%
  filter(`Procedure[Trial]`=="TrialProc" | 
           `Procedure[Trial]`=="PracTrialProc") %>%
  rename(TrialProc = `Procedure[Trial]`) %>%
  mutate(TrialProc = case_when(TrialProc == "TrialProc" ~ "real",
                               TrialProc == "PracTrialProc" ~ "practice"),
         RT = case_when(TrialProc == "real" ~ SlideTarget.RT,
                        TrialProc == "practice" ~ PracSlideTarget.RT),
         Trial = case_when(TrialProc == "real" ~ TrialList.Sample,
                           TrialProc == "practice" ~ PracTrialList.Sample),
         Accuracy = case_when(TrialProc == "real" ~ SlideTarget.ACC,
                              TrialProc == "practice" ~ PracSlideTarget.ACC),
         TargetArrowDirection = 
           case_when(TrialProc == "real" ~ TargetDirection,
                     TrialProc == "practice" ~ TargerDirection),
         Response = case_when(TrialProc == "real" ~ SlideTarget.RESP,
                              TrialProc == "practice" ~ PracSlideTarget.RESP),
         Response = case_when(Response == "z" ~ "left",
                              Response == "{/}" ~ "right")) %>%
  select(Subject, TrialProc, Trial, Condition = FlankerType, 
         RT, Accuracy, Response, TargetArrowDirection, 
         SessionDate, SessionTime)
#######################

#### Output ####
write_csv(data_raw, here(output_dir, output_file))
################

rm(list=ls())
