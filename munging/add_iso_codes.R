# setup
library(tidyverse)

# original dataset from kaggle
# file = https://www.kaggle.com/unitednations/international-energy-statistics
# code assumes you save this file in the following directory
# cannot upload raw file to Github, exceeds 100 MB
#raw_energy <-  read_csv("./data/all_energy_statistics.csv")

# all country details, courtesy of 
ISO_regions <- read_csv("./data/all.csv")

# join to use regional categories in this project (possibly map)
raw_energy_2 <- left_join(raw_energy, ISO_regions, by = c("country_or_area" = "name"))

# QC ISO codes
missing_iso <- raw_energy_2 %>% 
  filter(is.na(`alpha-3`)) %>% 
  count(country_or_area) %>% 
  arrange(desc(n)) 

# There are 43 'country_or_area' strings that were not compatable with ISO_regions table
# gsub on extracted column to be compatible
# countries identified as (former) in UN dataset were ignored (eg USSR)
names_fix <- raw_energy$country_or_area
names_fix <- gsub("United States", "United States of America", names_fix)
names_fix <- gsub("United Kingdom", "United Kingdom of Great Britain and Northern Ireland", names_fix)
names_fix <- gsub("Korea, Republic of", "Korea (Republic of)", names_fix)
names_fix <- gsub("T.F.Yug.Rep. Macedonia", "Macedonia (the former Yugoslav Republic of)", names_fix)
names_fix <- gsub("Iran (Islamic Rep. of)", "Iran (Islamic Republic of)", names_fix)
names_fix <- gsub("Venezuela (Bolivar. Rep.)", "Venezuela (Bolivarian Republic of)", names_fix)
names_fix <- gsub("Republic of Moldova", "Moldova (Republic of)", names_fix)
names_fix <- gsub("Bolivia (Plur. State of)", "Bolivia (Plurinational State of)", names_fix)
names_fix <- gsub("Korea, Dem.Ppl's.Rep.", "Korea (Democratic People's Republic of)", names_fix)
names_fix <- gsub("United Rep. of Tanzania", "Tanzania, United Republic of", names_fix)
names_fix <- gsub("Dem. Rep. of the Congo", "Congo (Democratic Republic of the)", names_fix)
names_fix <- gsub("China, Hong Kong SAR", "Hong Kong", names_fix)
names_fix <- gsub("Serbia and Montenegro", "Serbia", names_fix)
names_fix <- gsub("State of Palestine", "Palestine, State of", names_fix)
names_fix <- gsub("Lao People's Dem. Rep.", "Lao People's Democratic Republic", names_fix)
names_fix <- gsub("China, Macao SAR", "Macao", names_fix)
names_fix <- gsub("Faeroe Islands", "Faroe Islands", names_fix)
names_fix <- gsub("Central African Rep.", "Central African Republic", names_fix)
names_fix <- gsub("Falkland Is. (Malvinas)", "Falkland Islands (Malvinas)", names_fix)
names_fix <- gsub("St. Kitts-Nevis", "Saint Kitts and Nevis", names_fix)
names_fix <- gsub("St. Lucia", "Saint Lucia", names_fix)
names_fix <- gsub("St. Vincent-Grenadines", "Saint Vincent and the Grenadines", names_fix)
names_fix <- gsub("Micronesia (Fed. States of)", "Micronesia (Federated States of)", names_fix)
names_fix <- gsub("British Virgin Islands", "Virgin Islands (British)", names_fix)
names_fix <- gsub("St. Helena and Depend.", "Saint Helena, Ascension and Tristan da Cunha", names_fix)
names_fix <- gsub("St. Pierre-Miquelon", "Saint Pierre and Miquelon", names_fix)
names_fix <- gsub("Ethiopia, incl. Eritrea", "Ethiopia", names_fix)
names_fix <- gsub("Wallis and Futuna Is.", "Wallis and Futuna", names_fix)
names_fix <- gsub("United States Virgin Is.", "Virgin Islands (U.S.)", names_fix)
names_fix <- gsub("Bonaire, St Eustatius, Saba", "Bonaire, Sint Eustatius and Saba", names_fix)

# apply new names & rejoin for general use 
raw_energy_copy <- raw_energy
raw_energy_copy$country_or_area <- names_fix

raw_energy_2 <- left_join(raw_energy_copy, ISO_regions, by = c("country_or_area" = "name"))

#remove annoying hyphens from colnames
df_colnames <- colnames(raw_energy_2)
df_colnames <- gsub("-", "_", df_colnames)
colnames(raw_energy_2) <- df_colnames


# uncomment to write file
#write_csv(raw_energy_2, "./data/all_energy_statistics_plus_iso.csv")
# file omitted from github (exceeds 100 MB limit)