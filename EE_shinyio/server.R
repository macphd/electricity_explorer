#### Setup ####
library(shiny)
library(DT)
#### server.R ####

function(input, output, session) {

  # absolute vs relative capacity of electric power plants, 1999-2014
  output$capacity_plot <- renderPlot({
    delta_capacity %>%  
      filter() %>%
      ggplot(aes(x = abs_capacity, y = rel_capacity)) +   
      geom_point(aes(col = region), size = 2) +
      scale_x_log10(breaks = NULL) + scale_y_log10(breaks = NULL) +
      theme_bw() +
      labs(x = "----- Increasing capacity (kW, thousand) ----->",
           y = "----- Increaasing capacity (%) ----->",
           title = "Changes in electric capacity by country, 1999-2014") +
      theme(text = element_text(size = 24))
      
  })  
  
  #interactive feature: selecting countries
    output$brush_info <- renderPrint({
    brushedPoints(delta_capacity, input$plot1_brush)
  })
  
  # dissecting country electricity capacity
  output$country_plot <- renderPlot({
    electricity %>%
      filter(country_or_area == input$country_select,
             capacity != "total_capacity") %>%
      ggplot(aes(x = year, y = value, color = capacity)) +
      geom_line(size = 2, na.rm = TRUE) +
      theme_bw() +
      labs(x = "Year",
           y = "Electric capacity (kW, thousands)",
           title = "Changes in electric capacity by country, 1999-2014") +
      theme(text = element_text(size = 24))
                          
  })

### annualized histogram of non-combustible electricity capacity index
  output$renewables_plot <- renderPlot({
    electricity %>% 
      filter(year == input$region_commodity_year, 
             capacity == "total_capacity") %>% 
      select(alpha_3, region, non_combust_index) %>%   
      group_by(region) %>% 
      ggplot(aes(x = non_combust_index)) +
      geom_histogram(aes(fill = region), binwidth = 0.1) +
      ylim(0,20) +
      facet_wrap(~ region, ncol = 3) +
      theme_bw() +
      theme(text = element_text(size = 24)) +
      labs(x = "Non-Fossil Fuel Index")
  })
  
  # data table for reference
  output$table <- DT::renderDataTable({
    datatable(electricity, rownames=FALSE) %>% 
      formatStyle(input$selected, fontWeight='bold')
  })
}