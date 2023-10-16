library(shiny)
library(dplyr)

df <- read.csv("BodyFat.csv")

# Define server logic 
function(input, output, session) {
  
    # Data set reactive for further use in the appication 
    dataset <- reactive({
      df
    })
    
    # Observing change in the dataset in real time to make changes in the select input choices  
    observe({
      yChoices <- names(dataset())
      updateSelectInput(session = session,
                        inputId = "yvar",
                        choices = yChoices)
    })
    
    # Storing customized dataset (customization done by the user)
    datasetForModel <- reactive({
        req(input$xvar)
        dt <- df[,c(input$xvar)]
        return(dt)
    })
    
    # (DATA TAB) Displaying the data as a table
    output$dataTable <- DT::renderDT(DT::datatable(dataset(), style = "bootstrap"))
    
    # (DATA SUMMARY TAB) Displaying the summary and structure of data 
    output$summary <- renderPrint(summary(dataset()))
    output$oldSummary <- renderPrint(str(dataset()))
    
    # (CORRELATION COMPARISON TAB) Displaying the correlation comparison plots 
    output$correlationPlot <-
      renderPlot({
        cor_matrix <- cor(dataset() %>% select(-IDNO, -DENSITY))
        ggcorrplot::ggcorrplot(cor_matrix, hc.order = TRUE, type = "lower", lab = TRUE, colors = c("steelblue", "white", "#FF9999"))
      })
    
    output$corrcomparisonPlot <- 
      renderPlot({
        cor_matrix <- cor(dataset() %>% select(-IDNO))
        # Extract correlations with BODYFAT
        correlations_with_BODYFAT <- cor_matrix[, input$yvar]
        
        # Remove BODYFAT's correlation with itself (which will be 1)
        correlations_with_BODYFAT <- correlations_with_BODYFAT[!names(correlations_with_BODYFAT) %in% input$yvar]
        
        # Sort by the absolute value to see the strongest relationships
        sorted_correlations <- correlations_with_BODYFAT[order(-abs(correlations_with_BODYFAT))]
        
        # Visualize the sorted correlations using ggplot2
        ggplot2::ggplot(data.frame(Feature = names(sorted_correlations), Correlation = sorted_correlations), ggplot2::aes(x=reorder(Feature, Correlation), y=abs(Correlation), fill=Correlation > 0)) +
          ggplot2::geom_bar(stat="identity") +
          ggplot2::coord_flip() +
          ggplot2::scale_fill_manual(values = c("#FF9999", "steelblue"), name = "Correlation", breaks = c(TRUE, FALSE), labels = c("Positive", "Negative")) +
          ggplot2::ggtitle("Correlations with BODYFAT Without DENSITY") +
          ggplot2::xlab("Features") +
          ggplot2::ylab("Pearson Correlation Coefficient ") +
          ggplot2::theme_minimal()
      })
    
    # Splitting data into train and test data
    splitIndex <- reactive({
      caret::createDataPartition(datasetForModel()$BODYFAT, p = input$trainTestSlider / 100, list = FALSE)
    })
    
    trainData <- reactive({
      dm <- datasetForModel()
      dm[splitIndex(), ]
    })
    
    testData <- reactive({
      dm <- datasetForModel()
      dm[-splitIndex(), ]
    })
    
    # Finding Important Variables 
    vifComputed <- reactive({
      caret::varImp(linearModel())
    })
    
    # Building customized Linear Model 
    lmFormula <- reactive({
      as.formula(paste(input$yvar, "~."))
    })
    
    linearModel <- reactive({
      lm(lmFormula(), data = trainData())
    })
    
    # (MODEL TAB) Displaying the summary of the linear model applied 
    
    output$modelSummary <- renderPrint({
      return(summary(linearModel()))
    })
    
    output$variableImportance <- renderPrint({
      vifComputed()
    })
    
    
    # (PERFORMANCE TAB) Displaying plots related to the performance of the model 
    actuals <- reactive({
      t <- testData()
      return(t[,c(input$yvar)])
    })
    
    predicted <- reactive({
      predict(linearModel(), testData())
    })
    
    output$modelFit <- renderPlot({
      plot(
        actuals(), 
        predicted(), 
        main = "Best Fit Line",
        xlab = "Actual",
        ylab = "Predicted",
        col = "steelblue"
        )
    })
    
    output$residualPlots <- renderPlot({
      par(mfrow = c(2, 2))
      plot(linearModel())
    })
    
    
    # (PREDICT TAB) Taking input from the user to predict bodyfat
    
    bfPred <- reactive({
      idno <- nrow(dataset()) + 1
      values <- data.frame(
                  IDNO = idno, 
                  DENSITY = input$predDensity, 
                  BODYFAT = input$predBodyfat,
                  AGE = input$predAge, 
                  WEIGHT = input$predWeight, 
                  HEIGHT = input$predHeight, 
                  ADIPOSITY = input$predAdiposity, 
                  NECK = input$predNeck, 
                  CHEST = input$predChest, 
                  ABDOMEN = input$predAbdomen, 
                  HIP = input$predHip, 
                  THIGH = input$predThigh, 
                  KNEE = input$predKnee, 
                  ANKLE = input$predAnkle, 
                  BICEPS = input$predBiceps,
                  FOREARM = input$predForearm,
                  WRIST = input$predWrist
                )  
      
      return(predict(linearModel(), values))
    })
    
    output$bodyFatPred <- renderPrint({
      paste0("Your predicted independent variable is: ", bfPred()[[1]])
    })
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  
}
