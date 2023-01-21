library(shiny)
library(shinydashboard)
library(tidyverse)

header <- dashboardHeader(title = "Machine Learning")
  
sidebar <- dashboardSidebar(
  sidebarMenu(id="tabs",
              menuItem("About",
                       tabName = "about", 
                       icon = icon("info")),
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
          
          # about
          tabItem(tabName = "about",
                  
                  box(title = 'How to use',status = "primary",
                      
                  p('Follow the steps below if you are unfamiliar with Machine Learning and wish to use this dashboard.'),
                  
                  
                  
                  tabItem(tabName = "clustering",
                          tabsetPanel(type = "tabs",
                                      tabPanel("1",
                                               br(),
                                               strong('Upload your data'),br(),br(),
                                               p('The data must be in a csv file and seperated by comma\'s ( , ) or semicolons ( ; ).
                                               
                                               
                                                ')
                                              ),
                                      tabPanel("2", 
                                               br(),
                                               strong('Explore your data'),br(),br()
                                              )
                                    )
                          )
                  )
                  
          ),
          
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
