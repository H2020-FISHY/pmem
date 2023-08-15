# Load required libraries
library(shiny)
# Load UI code from ui.R file
source("ui.R")
# Load server code from server.R file
source("server.R")
# Run the Shiny application
shinyApp(ui = ui, server = server)
