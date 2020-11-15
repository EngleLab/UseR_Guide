## Set up ####
## Load packages
library(readr)
library(dplyr)
library(here)
library(datawrangling)
library(englelab)

## Set import/output directories
import_dir <- "Data Files/Raw Data"
output_dir <- "Data Files/Scored Data"
removed_dir <- "Data Files/Scored Data/removed"

## Set import/output files
task <- "Flanker"
import_file <- paste(task, "_raw.csv", sep = "")
output_file <- paste(task, "_Scores.csv", sep = "")
removed_file <- paste(task, "_removed.csv", sep = "")

## Set Trimming criteria
rt_min <- 200
acc_criteria <- -3.5
##############

## Import Data
data_import <- read_csv(here(import.dir, import.file)) %>%
  filter(TrialProc == "real")
###################

## Trim RTs ####
data_trim <- data_import %>%
  filter(TrialProc == "real") %>%
  mutate(Accuracy = ifelse(RT < rt_min, 0, Accuracy),
         RT = ifelse(RT < rt_min, NA, RT))
################

## Calculate Flanker scores using Accurate trials only ####
data_flanker <- data_trim %>%
  mutate(RT = ifelse(Accuracy == 0, NA, RT)) %>%
  group_by(Subject, Condition) %>%
  summarise(RT.mean = mean(RT, na.rm = TRUE),
            ACC.mean = mean(Accuracy, na.rm = TRUE)) %>%
  ungroup() %>%
  pivot_wider(id_cols = "Subject",
              names_from = "Condition",
              values_from = c("RT.mean", "ACC.mean")) %>%
  mutate(FlankerEffect_RT = RT.mean_incongruent - RT.mean_congruent,
         FlankerEffect_ACC = ACC.mean_incongruent - ACC.mean_congruent)
###########################################################

## Remove subjects with poor performance based on acc_criteria ####
data_remove <- data_flanker %>%
  center(variables = c("ACC.mean_congruent", 
                       "ACC.mean_incongruent"), 
         standardize = TRUE) %>%
  filter(ACC.mean_congruent_z < acc.criteria |
           ACC.mean_incongruent_z < acc.criteria)

data_flanker <- remove_save(data_flanker, data_remove,
                            output.dir = removed_dir,
                            output.file = removed_file)

## Calculate Bin Scores ####
data_binned <- data_trim %>%
  filter(!is.na(RT), !(Subject %in% data_remove$Subject)) %>%
  bin_score(condition.col = "Condition", baseline.condition = "congruent") %>%
  rename(FlankerBin = "BinScore")
############################

## Merge Flanker and Binned scores, then save ####
data_flanker <- merge(data_flanker, data_binned, by = "Subject", all = TRUE)
write_csv(data_flanker, path = here(output.dir, output.file))
##################################################

rm(list=ls())
