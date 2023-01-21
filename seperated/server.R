library(shiny)
library(shinydashboard)
library(tidyverse)
library(dbscan)

# GLOBAL
options(shiny.maxRequestSize=100*1024^2) # max file size of 100 MB

# THEME




server <- function(input, output, session){
  
    # file import
    df <- reactive({
        inFile <- input$csv_file
        
        if (is.null(inFile))
            return(NULL)
        df <- read.csv(inFile$datapath, sep = input$seperator)
        
        numeric_var <- colnames(df)[!grepl('factor|logical|character',sapply(df,class))]
        categorical_var <- colnames(df)[grepl('factor|logical|character',sapply(df,class))]
        
        df[grepl("Date$", names(df))] <- lapply(df[grepl("Date$", names(df))], function(x) as.Date(x, format = "%m/%d/%Y"))
        
        
        updateSelectInput(session,"numVar",choices=numeric_var)
        updateSelectInput(session,"catVar",choices=categorical_var)
        updateSelectInput(session,"groupBy",choices=categorical_var)
        
        updateSelectInput(session,"colOutlier",choices=colnames(df))
        updateSelectInput(session,"colClust1",choices=numeric_var)
        updateSelectInput(session,"colClust2",choices=numeric_var)
        updateSelectInput(session,"colClust1d",choices=numeric_var)
        updateSelectInput(session,"colClust2d",choices=numeric_var)
        return(df)    
    })
    
    
    # dataframe table
    output$dataTable <- renderDataTable(df(),
                                        options = list(scrollX = TRUE))
    
    output$dataSummary <- renderPrint(df() %>% summary())
    
    
    # distribution plot
    output$cat_hist <- renderPlot({
        x <- df()[,input$catVar]
        
        df() %>% ggplot(aes(x)) +
          geom_bar() +
          xlab(input$catVar) +
          theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
        
    })
    
    output$density <- renderPlot({
      x <- df()[,input$numVar]
      
      df() %>% ggplot(aes(x)) +
        geom_density(fill='red') +
        xlab(input$numVar)
      
    })
    
    # Scatterplot with category
    output$scatter <- renderPlot({
      
      df <- df()[,c(input$colClust1,input$colClust2)]
      
      col1 <- sym(input$colClust1)
      col2 <- sym(input$colClust2)
      
      df() %>% ggplot(aes(x= !! col1, 
                          y= !! col2,
                          color=.data[[input$groupBy]])) +
        geom_point() +
        xlab(input$colClust1) +
        ylab(input$colClust2)
      
    })
    
    
    # outlier plot
    output$outlierPlot <- renderPlot({
        
        if (input$outlierMethod == 'Statistical'){
            # statistical outlier is one that is more than 3 sigma from the mean
            
            y <- df()[,input$colOutlier]
            mu <- mean(y)
            sigma <- sd(y)
            
            df_temp <- as.data.frame(y)
            
            df_temp <- df_temp %>% mutate(distance = abs(y-mu))
            df_temp <- df_temp %>% mutate(outlier = ifelse(distance > 3*sigma,'Outlier','No outlier'))
            
            df_temp %>% ggplot(aes(row_number(),y,color=outlier)) + geom_point()
        } else if (input$outlierMethod == 'Distance'){
            # Not yet implemented
            return()
        }
            
    })
    
    
    # clusterplot
    output$clusterPLot <- renderPlot({
        
        df <- df()[,c(input$colClust1,input$colClust2)]
        
        col1 <- sym(input$colClust1)
        col2 <- sym(input$colClust2)
        
        
            # perform k means clustering
            k <- kmeans(df,centers = input$numberClusters)
            
            clusters <- as.factor(k$cluster)
            
            df() %>% ggplot(aes(x= !! col1, 
                                y= !! col2,
                                color=clusters)) +
                geom_point() +
                xlab(input$colClust1) +
                ylab(input$colClust2)
        
    })
    
    
    
    
}
