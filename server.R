

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  .libPaths( c( .libPaths(), "/srv/shiny-server/renv/library/R-4.1/x86_64-pc-linux-gnu") )
  #.libPaths(c("./library",.libPaths()))
    library(shiny)
#  library(lessR)
  library(DT)
  library(ggplot2)
  library(plotly)
  get.data <- function(x){
    library(shiny)
#    library(lessR)
    library(DT)
    library(ggplot2)
    library(plotly)
    if(file.exists("./Data/prediction_result.csv")){
      results<-read.csv("./Data/prediction_result.csv")
    }else {
      print("waiting for the data")
      Sys.sleep(10)
      get.data()  
    }
    
    #results$Label <- ifelse(results$Label,"Benign","Malicious")
    pred_label<-results$Label
    return(results)
  }

  # R E A C T I V E
  liveish_data <- reactive({
    shiny::invalidateLater(20000)
    get.data()                # call our function from above
    
  })
#############################################
  output$distPlot <-renderPlotly({
    
    tryCatch({
      df <-  liveish_data()
      labels <- names(table(df$Label))
      #      values <- as.numeric(table(df$Label))
      values <- table(df$Label)
      plot_ly(labels = labels, values = values, type = "pie",  marker = list(colors = c("lightpink", "lightgreen")))
    }, 
    error = function(e) {
      return(ggplot())
    }
    )
  })
    # output$distPlot <- shiny::renderPlot({
    #   results <- liveish_data()
    #   #results$Label <- ifelse(results$Label,"Benign","Malicious")
    #   #pred_label <- results$Label
    #   #pred_label <- ifelse(pred_label,"Benign","Malicious")
    #   
    #   #gender <- data.frame(gend = pred_label)
    # 
    #   #lessR::PieChart(gend, hole = 0, values = "%", data = gender,
    #   #                   fill = c("#4285F4","#B76C9E"), main = "Last Scan Percentage")
    #   lessR::PieChart(Label,hole = 0.2,,hole_fill = "#B7E3E0",data =results )
    # })
  output$tabla <- DT::renderDataTable({
    results<-liveish_data()
    results<-results[results$Label != 'Benign', ]
    #results$Label <- ifelse(results$Label,"Benign","Malicious")
  tabla<-DT::datatable(results[,c("Label","Src.IP","Dst.IP","Timestamp")],
                       rownames = FALSE,
                       extensions = 'Buttons',
                       options = list(pageLength=5,
                                      autoWidth = TRUE,
                                      dom = 'Blfrtip',
                                      buttons = c('csv', 'excel', 'pdf'),
                                      lengthMenu = list(c(5,25,50,-1),
                                                        c(5,25,50,"All"))))
  
  tabla})

})
