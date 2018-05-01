#load foundation packages
library(tidyverse)
#load data
electricity <- read_csv("../data/electricity_stats.csv")

#load delta_capacity to global for brushedpoints
delta_capacity <- electricity %>% 
  filter(capacity == "total_capacity") %>% 
  group_by(country_or_area, region) %>% 
  summarise(abs_capacity = max(value, na.rm = TRUE) - min(value,na.rm = TRUE),
            rel_capacity = abs_capacity / min(value, na.rm = TRUE))
