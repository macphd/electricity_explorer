# setup
library(tidyverse)

# updated dataset with ISO codes
# code assumes add_iso_codes step first
# the earlier csv exceeds Github limit of 100 MB so it is not included here
energy_total <-  read_csv("../data/all_energy_statistics_plus_iso.csv")
unique(energy_total$category)

# For the sake of a nimble Shiny app, I'll need to trim this df (1.2e6 obs.)
# 
# I followed the following process:
# 1) Filtered for desired observations
#    - select for data pertaining to electric power plant capacity
#    - omit countries that don't exist anymore eg: USSR
# 2) Select/rename columns that will be used in the app
#    - should cut the df in half with this step (eg: don't need alpha_2 and alpha_3)
# 3) Mutate new variables 
#    - non_combust sums all electric capacity that does not use fossil fuels
#    - non_combust_index is the percent of non_combust normalized by total capacity
# 4) Re-gather capacity variables

electricity <- energy_total %>% 
  filter(category == "electricity_net_installed_capacity_of_electric_power_plants",
         !is.na(alpha_3)) %>% 
  spread(commodity_transaction, quantity) %>% 
  select(7, 1, 2, 10, 11, total_capacity = 35,
         `fossil fuels` = 31, solar = 37,
         geothermal = 32, hydro = 33,
         nuclear = 36, wind = 39,
         tide = 38) %>%
  group_by(year, alpha_3) %>% 
  mutate(`non-fossil fuels` = sum(solar, geothermal, hydro,
                           nuclear, wind, tide, na.rm = TRUE),
         non_combust_index = sqrt(`non-fossil fuels`/total_capacity)) %>% 
  gather(key = "capacity", value = "value", 6:14)

#OK, now I have a dataset for the app less than 10k but richer in variables

# confirm unique units by category
capacity_units <- energy_total %>% 
  filter(category == "electricity_net_installed_capacity_of_electric_power_plants")
unique(capacity_units$unit)
# all units for quantities in installed_capacity category are as "kW, thousand"
# therefore, I can omit the 'units column from the df' and manually add to figures

#uncomment to write
#write_csv(electricity, "../data/electricity_stats.csv")
