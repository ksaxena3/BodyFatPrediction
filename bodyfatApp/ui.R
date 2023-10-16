library(shiny)

df <- read.csv("BodyFat.csv")

# Define UI for application 
fluidPage(
    theme = shinythemes::shinytheme("slate"),
    # Application title
    titlePanel("Body Fat Predictor"),

    # Sidebar with a slider input for train test split  
    sidebarLayout(
        sidebarPanel(
          width = 2,
          sliderInput(
            "trainTestSlider",
            label = "Train Test split",
            min = 0,
            max = 100,
            value = 80
          ),
          br(),
          selectInput(
            "xvar",
            label = "Select dependent variables:",
            choices = names(df),
            multiple = TRUE,
            selected = names(df)
          ),
          selectInput("yvar", label = "Select independent variable:", choices = names(df))
        ),

        # Main Panel including all the tabs - (Data, Summary, Correlation comparison, Model and Predictions)
        mainPanel(
          width = 10, 
          tabsetPanel(
            tabPanel("Data",
                     fluidRow(
                       column(
                         width =12,
                         shinycssloaders::withSpinner(DT::DTOutput("dataTable"))
                       )
                     )
            ),
            tabPanel("Data Summary",
                     fluidRow(
                       column(
                         width = 6,
                         shinycssloaders::withSpinner(verbatimTextOutput("summary"))
                       ),
                       column(
                         width = 6,
                         shinycssloaders::withSpinner(verbatimTextOutput("oldSummary"))
                       )
                     )
            ),
            tabPanel("Correlation Comparison",
                     fluidRow(
                       column(
                         width = 6, 
                         shinycssloaders::withSpinner(plotOutput("correlationPlot",  height = 800))
                       ),
                       column(
                         width = 6, 
                         shinycssloaders::withSpinner(plotOutput("corrcomparisonPlot",  height = 800))
                       )
                     )
              
            ),
            tabPanel("Model Summary",
                      fluidRow(
                        column(
                          width = 6,
                          shinycssloaders::withSpinner(verbatimTextOutput("modelSummary"))
                        ),
                        column(
                          width = 6,
                          shinycssloaders::withSpinner(verbatimTextOutput("variableImportance"))
                        )
                      )         
            ),
            tabPanel("Performance",
                      fluidRow(
                        column(
                          width = 6, 
                          shinycssloaders::withSpinner(plotOutput("modelFit", height = 800))
                        ),
                        column(
                          width = 6, 
                          shinycssloaders::withSpinner(plotOutput("residualPlots", height = 800))
                        )
                      )         
            ),
            tabPanel("Predict",
                     fluidRow(
                       column(
                         width = 1, 
                         numericInput("predAge", "Age: ", value = 25),
                       ),
                       column(
                         width = 1, 
                         numericInput("predWeight", "Weight: ", value = 178),
                       ),
                       column(
                         width = 1, 
                         numericInput("predHeight", "Height: ", value = 70),
                       ),
                       column(
                         width = 1, 
                         numericInput("predChest", "Chest: ", value = 100),
                       ),
                       column(
                         width = 1, 
                         numericInput("predAbdomen", "Abdomen: ", value = 92),
                       ),
                       column(
                         width = 1, 
                         numericInput("predThigh", "Thigh: ", value = 59),
                       ),
                       column(
                         width = 1, 
                         numericInput("predNeck", "Neck: ", value = 38),
                       ),
                       column(
                         width = 1, 
                         numericInput("predAdiposity", "Adiposity: ", value = 25),
                       ),
                       column(
                         width = 1, 
                         numericInput("predHip", "Hip: ", value = 99),
                       ),
                       column(
                         width = 1, 
                         numericInput("predAnkle", "Ankle: ", value = 23),
                       ),
                       column(
                         width = 1, 
                         numericInput("predBiceps", "Biceps: ", value = 32),
                       ),
                       column(
                         width = 1, 
                         numericInput("predForearm", "Forearm: ", value = 28),
                       ),
                       column(
                         width = 1, 
                         numericInput("predWrist", "Wrist: ", value = 18),
                       ),
                       column(
                         width = 1, 
                         numericInput("predKnee", "Knee: ", value = 18),
                       ),
                       column(
                         width = 1, 
                         numericInput("predDensity", "Density: ", value = 1.056),
                       ),
                       column(
                         width = 1, 
                         numericInput("predBodyfat", "Bodyfat: ", value = 18.94),
                       )
                     ),
                     br(),
                     fluidRow(
                       column(width = 6,
                          verbatimTextOutput("bodyFatPred")      
                        )
                     )
            )
          )
        )
    )
)
