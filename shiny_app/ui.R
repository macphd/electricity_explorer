#### Setup ####
library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
#### ui.R ####

dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "UN Electricity Explorer"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Explore", tabName = "explore", icon = icon("globe")),
      menuItem("Non-Fossil Fuel Index", tabName = "renewables", icon = icon("recycle")),
      menuItem("Analyze", tabName = "analyze", icon = icon("bolt")),
      menuItem("Data", tabName = "data", icon = icon("table"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "explore",
        fluidRow(
          column(width = 3, 
            box(title = "Which countries have invested in electricity production?",
                width = NULL, 
                solidHeader = TRUE,
                status = "warning",
                "This graph visualizes changes in electricity infrastructure for
                countries (points) and regions (colors) from 1999 - 2014, [1] 
                "),
            box(title = "Rationale: Energy Infrastructure",
                width = NULL,
                status = "warning",
                "Building a power plant represents a long-term committment to that energy strategy.",
                br(), br(),
                "Identifying growth countries for trading resources or promoting alternative
                energy strategies could help achieve economic and environmental goals.",
                hr(),
                "This UN energy statistics dataset is bookended by the Kyoto treaty and Paris agreement.",
                tags$a(href="https://www.cnn.com/2013/07/26/world/kyoto-protocol-fast-facts/index.html", "See timeline.")
                )
          ),
          column(width = 9,
            box(title = NULL,
                width = NULL,
                background = "yellow",
                height = 600,
            plotOutput(outputId = "capacity_plot",
                     height = 580,
                     brush = brushOpts(
                       id = "plot1_brush",
                       resetOnNew = TRUE))),
            
            box(title = "Select countries above",
                width = NULL,
                status = "warning",
                verbatimTextOutput("brush_info"),
                "[1]: Visualization is on a log-log scale to 
                minimize country overlap.") # stretch printout?
          )
        )
      ), 
      tabItem(tabName = "analyze",
        fluidRow(
          column(width = 3,
                 box(title = "Dissecting Electric Capacity by Country",
                     width = NULL, 
                     solidHeader = TRUE, 
                     status = "warning",
                     "Now that you've explored through the 
                      previous tabs, investigate details about electricity 
                      capacity for your country of interest."
                 ),
                  box(title = "Select a country",
                     width = NULL, 
                     status = "warning",
                     selectizeInput('country_select', 'Select or type in a country name:', 
                                    choices = electricity$country_or_area))
          ),
          column(width = 9,
                 box(title = NULL,
                     width = NULL,
                     height = 600,
                     background = "yellow",
                     plotOutput(outputId = "country_plot",
                                height = 580,
                                width = NULL)))
        )
      ),
      tabItem(tabName = "renewables",
        fluidRow(
          column(width = 3,
                  box(title = "How has non-combustible electricity capacity changed?",
                      width = NULL, 
                      solidHeader = TRUE, 
                      status = "warning",
                      "The non-combustible index is proportion of electric capacity that
                      does not explicity rely on fossil fuels normalized by total capacity.",
                      br(), br(),
                      "Changing electricity infrastructure is slow and expensive, but some
                      regions are changing energy strategies faster than others.",
                      hr(),
                      "Click the play button below, or select a year of interest."),
                  box(title = "Select inputs",
                      width = NULL, 
                      status = "warning",
                      sliderInput("region_commodity_year", "Year:",
                                  min = 1999, max = 2014,
                                  value = 1999, step = 1,
                                  sep = "", animate = TRUE))
                ),
                column(width = 9,
                       box(width = NULL,
                           height = 600,
                           background = "yellow",
                           plotOutput(outputId = "renewables_plot", height = "580px")
                      )
                )
        )
    ),
    tabItem(tabName = "data",
            fluidRow(
              column(width = 12,
                     box(title = "Data Table for reference",
                         width = NULL, 
                         solidHeader = TRUE, 
                         status = "warning",
                         DT::dataTableOutput("table"),
                          tags$a(href="https://github.com/mikeacaballero", "Check out my GitHub for code & data!"))
            )
    )
)
)
)
)
