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
      labs(x = "----- Increased capacity, absolute ----->",
           y = "----- Increased capacity, relative ----->",
           title = "Changes in electric capacity by country, 1999-2014") +
      theme(text = element_text(size = 24))
      
  })  
  
  #interactive feature: selecting countries
    output$brush_info <- renderPrint({
    brushedPoints(delta_capacity, input$plot1_brush)
  })
  
  # annualized histogram of non-combustible electricity capacity index
  output$renewables_plot <- renderPlot({
    electricity %>% 
      filter(year == input$region_commodity_year, 
             variable == "non_combust_index") %>% 
      select(alpha_3, region, value) %>%   
      group_by(region) %>% 
      ggplot(aes(x = value)) +
      geom_histogram(aes(fill = region), binwidth = 0.1) +
      ylim(0,20) +
      facet_wrap(~ region, ncol = 3) +
      theme_bw() +
      theme(text = element_text(size = 24)) +
      labs(x = "Non-Fossil Fuel Index")
  })  
    
  # dissecting country electricity capacity
  output$country_plot <- renderPlot({
    electricity %>%
      filter(country_or_area == input$country_select,
             variable != ("non_combust_index")) %>%
      ggplot(aes(x = year, y = value, color = variable)) +
      geom_line(size = 2) +
      theme_bw() +
      labs(x = "Year",
           y = "Electric capacity (kW, thousands)",
           title = input$country_select , 
           subtitle = "Electric capacity by type, 1999-2014" ) +
      theme(text = element_text(size = 24))
                          
  })
  
  # data table for reference
  output$table <- DT::renderDataTable({
    datatable(electricity, rownames=FALSE) %>% 
      formatStyle(input$selected, fontWeight='bold')
  })
}