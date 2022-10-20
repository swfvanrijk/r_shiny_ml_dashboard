library(shiny)
library(shinydashboard)
library(tidyverse)
library(dbscan)

header <- dashboardHeader(title = "AutoML 2.0",
                          dropdownMenu(type = "notifications",
                                       notificationItem(
                                         text = "5 new users today",
                                         icon("users")
                                       ),
                                       notificationItem(
                                         text = "12 items delivered",
                                         icon("truck"),
                                         status = "success"
                                       ),
                                       notificationItem(
                                         text = "Server load at 86%",
                                         icon = icon("exclamation-triangle"),
                                         status = "warning"
                                       )),
                          dropdownMenu(type = "tasks", badgeStatus = "success",
                                       taskItem(value = 90, color = "green",
                                                "Documentation"
                                       ),
                                       taskItem(value = 17, color = "aqua",
                                                "Project X"
                                       ),
                                       taskItem(value = 75, color = "yellow",
                                                "Server deployment"
                                       ),
                                       taskItem(value = 80, color = "red",
                                                "Overall project"
                                       )
                          )
            )
  
sidebar <- dashboardSidebar(
  sidebarMenu(id="tabs",
              menuItem("File",
                       tabName = "file", 
                       icon = icon("file-csv")),
              menuItem("Exploratory Data Analysis", 
                       tabName = "distribution", 
                       icon = icon("chart-bar")),
              menuItem("Outlier", 
                       tabName = "outlier", 
                       icon = icon("crosshairs")),
              menuItem("Clustering", 
                       tabName = "clustering",
                       icon = icon("chart-pie")),
              menuItem("Regression", 
                       tabName = "regression",
                       icon = icon("chart-line"),
                       badgeLabel = "new", badgeColor = "green"),
              menuItem("Classification", 
                       tabName = "classification",
                       icon = icon("percent"),
                       badgeLabel = "new", badgeColor = "green"),
              
              menuItem("Source code", icon = icon("file-code-o"), 
                       href = "https://github.com/rstudio/shinydashboard/")
  )
)
  
body <- dashboardBody(
        tabItems(
          
            # File
            tabItem(tabName = "file",
                    
                    fluidRow(
                      box(title = "File", status = "primary", solidHeader = TRUE,
                        fileInput('csv_file',
                                    'Choose a csv file to analyze', 
                                    accept = ".csv"),
                      radioButtons("seperator",
                                       "Seperator",
                                       c(',',';'),
                                       inline=T)
                      ),
                      box(title='Summary',
                          verbatimTextOutput("dataSummary"))
                    ),
                    box(title = 'Dataframe',
                        status = "primary",
                        width = 12,
                        solidHeader = TRUE,
                        collapsible = TRUE,
                        dataTableOutput("dataTable") )
                    
            ),
            
            # Distribution
            tabItem(tabName = "distribution",
                    
                    fluidRow(
                      tabBox(
                        title = "Distributions",
                        # The id lets us use input$tabset1 on the server to find the current tab
                        id = "tabset1",
                        tabPanel("Categorical",icon=icon("chart-column"),
                                 selectInput("catVar", 
                                             "Column", 
                                             c()), 
                                 # column names will be updated after file upload
                                 plotOutput("cat_hist")
                        ),
                        tabPanel("Numeric",icon=icon("chart-area"), 
                                 selectInput("numVar", 
                                             "Column", 
                                             c()), 
                                 # column names will be updated after file upload
                                 plotOutput("density")
                        )
                      ),
                      box(
                        title = 'Scatter with category',
                        selectInput("groupBy", 
                                    "Categorize by", 
                                    c()),
                        selectInput("colClust1", "x axis",c()),
                        # column names will be updated after file upload
                        selectInput("colClust2", "y axis",c()),
                        plotOutput('scatter')
                    
                      ),
                    ),
                    fluidRow(
                      tabBox(
                        # Title can include an icon
                        title = tagList(shiny::icon("gear"), "tabBox status"),
                        tabPanel("Tab1",
                                 "Currently selected tab from first box:",
                                 verbatimTextOutput("tabset1Selected")
                        ),
                        tabPanel("Tab2", "Tab content 2")
                      )
                    )
            ),
            
            # Outlier
            tabItem(tabName = "outlier",
                    selectInput("colOutlier", "Column",c()),
                    # column names will be updated after file upload
                    selectInput("outlierMethod", 
                                "Outlier detection method",
                                c('Statistical','Distance')),
                    plotOutput('outlierPlot')
            ),
            
            # Clustering
            tabItem(tabName = "clustering",
                    tabsetPanel(type = "tabs",
                        tabPanel("kMeans",
                                 selectInput("colClust1", "x Column",c()),
                                 # column names will be updated after file upload
                                 selectInput("colClust2", "y Column",c()),
                                 # column names will be updated after file upload
                                 selectInput("numberClusters", 
                                             "Number of clusters",
                                             c(2,3,4,5,6)),
                                 plotOutput('clusterPLotk')
                                 ),
                        tabPanel("DBSCAN", 
                                 selectInput("colClust1d", "x Column",c()),
                                 # column names will be updated after file upload
                                 selectInput("colClust2d", "y Column",c()),
                                 # column names will be updated after file upload
                                 plotOutput('clusterPLotd')
                                 )
                    )
            ),
            
            # Regression
            tabItem(tabName = "regression",
                    h2('Regression'),
                    p('sjhbghbsghjsbgkj'),
                    infoBox("Model summary", 10 * 2, icon = icon("chart-line"))
                    
            ),
            
            # Classification
            tabItem(tabName = "classification",
                    h2('Classification'),
                    p('sjhbghbsghjsbgkj'),
                    infoBox("Model summary", 10 * 2, icon = icon("percent"))
                    
            )
            
        )
    )



ui <- dashboardPage(header, sidebar, body)
