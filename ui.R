.libPaths( c( .libPaths(), "/srv/shiny-server/renv/library/R-4.1/x86_64-pc-linux-gnu") )
#.libPaths(c("./library",.libPaths()))
library(shiny)
library(shinydashboard)
library(sparkline)
library(DT)
library(ggplot2)
library(plotly)
# Define UI for application that draws a histogram
# Setup Shiny app UI components -------------------------------------------
# Simple header -----------------------------------------------------------
header <- dashboardHeader(title="PMEM Dashboard")
# Sidebar --------------------------------------------------------------
sm <- sidebarUserPanel("FISHY -- https://fishy-project.eu")
sidebar <- dashboardSidebar(sm,collapsed = TRUE)
# Body
body <- dashboardBody(
  fluidRow(
    
    column(8,
           box(
             title="Last Scan Results",
             solidHeader = T,
             br(),
             DT::dataTableOutput("tabla"),
             width = 12,
             height = "400px"
           )       
    ),
    
    column(4,
           plotlyOutput("distPlot")
           
    )
  )
)
ui <- dashboardPage(header, sidebar, body, skin="black")

