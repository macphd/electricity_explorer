#load foundation packages
library(tidyverse)
#load data
electricity <- read_csv("electricity_stats.csv")

# delta_capacity in global to enable brushpoint selection
delta_capacity <- electricity %>%
  filter(variable == "total capacity") %>%
  group_by(country_or_area, region) %>%
  summarise(abs_capacity = max(value, na.rm = TRUE) - min(value,na.rm = TRUE),
            rel_capacity = abs_capacity / min(value, na.rm = TRUE))