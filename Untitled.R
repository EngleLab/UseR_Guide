library(readr)
library(here)

Flanker <- datawrangling::duplicates.remove(Flanker)

for (subj in unique(Flanker$Subject)){
  data <- filter(Flanker, Subject == subj)
  write_delim(data, path = here())
}
