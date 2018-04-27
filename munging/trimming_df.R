# setup
library(tidyverse)

# updated dataset with ISO codes
# code assumes add_iso_codes step first
# the earlier csv exceeds Github limit of 100 MB so it is not included here
#energy_total <-  read_csv("./data/all_energy_statistics_plus_iso.csv")

# For the sake of a nimble Shiny app, I'll need to trim this df
# ~1.2e6 observations and 17 variables
# 
# I followed the following process:
# 1) Separate the 'commodity_transaction' column
#    - commodity is a more granular description of the 'category' column
#    - transaction holds a tremendous amount of content eg: import/export/use etc...
# 2) Select columns that will be used in the app
#    - should cut the df in half with this step (eg: don't need alpha_2 and alpha_3)
# 3) Filter out observations of limited value
#    - omit countries that don't exist anymore eg: USSR
#    - this app will focus on electricity, so I include a category-level filter

colnames(energy_total)

electricity <- energy_total %>% 
  separate(commodity_transaction, into = c("commodity", "transaction"), sep = " - ") %>% 
  select(alpha_3, country_or_area, commodity, transaction, year, unit, quantity, category, region, sub_region) %>% 
  filter(!is.na(alpha_3), 
         category == c("electricity_net_installed_capacity_of_electric_power_plants", "total_electricity"))

# OK! about 90k observations and 9 variables... oom less than original df
# Lets do a little more tidying before writing the file

# let's make the category for installed electricity plants less obscene
elec_categories <- electricity$category
elec_categories <- gsub("electricity_net_installed_capacity_of_electric_power_plants", "installed_capacity", elec_categories)  
electricity_2 <- electricity
electricity_2$category <- elec_categories

# confirm unique units by category
capacity_units <- electricity_2 %>% 
  filter(category == "installed_capacity")
unique(capacity_units$unit)
# all units for quantities in installed_capacity category are as "kW, thousand"
production_units <- electricity_2 %>% 
  filter(category == "total_electricity")
unique(production_units$unit)
# all units for quantities in total_electricity category are "kWh, million"
# therefore, I can omit the 'units column from the df' and manually add to figures

electricity_3 <- electricity_2 %>% 
  select(-unit)

#uncomment to write
#write_csv(electricity_3, "./data/electricity_stats.csv")
