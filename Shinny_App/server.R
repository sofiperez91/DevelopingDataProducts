#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(plotly)
library(caret)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    data(mtcars)
    # PLOT
    var_1<-reactive({
        mtcars[,as.numeric(input$var_1)]
    })
    var_2<-reactive({
        mtcars[,as.numeric(input$var_2)]
    })
    var_3<-reactive({
        mtcars[,as.numeric(input$var_3)]
    })
    x_lab<-reactive({
        colnames(mtcars)[as.numeric(input$var_1)]
    })
      color_lab<-reactive({
          colnames(mtcars)[as.numeric(input$var_3)]
    })
    output$Plot_2 <- renderPlotly({
        plot_ly(mtcars,x=var_1(),y=~mpg , type = "scatter", mode = "markers", marker = list(size = ~var_2()*4, colorbar = list(title = color_lab()), color = ~var_3(), colorscale='Viridis', reversescale =T)) %>% 
            layout(title = "Manual Transmission cars", xaxis = list(title = x_lab()), 
                   yaxis = list(title = "Miles per gallon"))
    })

    #Regression Analysis
    output$Summary<-renderText({
    "The following analysis will show that ~87% of the variance in mpg can be attributed to the variables: cylinders (cyl), power (hp), weight (wt) and transmission type (am)." 
    })
    output$Model_1<-renderPrint({
        mtcars$am <- as.factor(mtcars$am)
        mtcars$tx_type <- factor(mtcars$am, labels=c("Automatic","Manual"))
        mtcars$cyl <- as.factor(mtcars$cyl)
        mtcars$vs <- as.factor(mtcars$vs)
        mtcars$gear <- as.factor(mtcars$gear)
        mtcars$carb <- as.factor(mtcars$carb)
        fit<-lm(mpg ~ ., mtcars)
        fit
    })
    output$Step<-renderText({
        "The function *step()* is used for choosing the best model. 
The function basically will remove variables and analize the AIC until it obtains the lower value."
    })
    output$Model_2<-renderPrint({
        mtcars$am <- as.factor(mtcars$am)
        mtcars$tx_type <- factor(mtcars$am, labels=c("Automatic","Manual"))
        mtcars$cyl <- as.factor(mtcars$cyl)
        mtcars$vs <- as.factor(mtcars$vs)
        mtcars$gear <- as.factor(mtcars$gear)
        mtcars$carb <- as.factor(mtcars$carb)
        fit<-lm(mpg ~ ., mtcars)
        Model <- step(fit, direction = "backward")
        Model
        summary(Model)$r.squared
    })
    output$Conclusion<-renderText({
        "Considering that the R-squared value for this test is ~0.866 Which means that over 86% of the variance in mpg can be attributed to the variables: cylinders (cyl), power (hp), weight (wt) and transmission type (am)."    
        })
    
    # Prediction Analysis

    user_input<-reactive({
        user_input<-data.frame(input$user_cyl,input$user_hp,input$user_wt,input$user_am)
        colnames(user_input)<-c("cyl","hp","wt","am")
        user_input$cyl <- as.numeric(user_input$cyl)
        user_input$am <- as.numeric(user_input$am)
        user_input
        })
    data<-mtcars[,c(1,2,4,6,9)]
    row.names(data)<-c()
    inTrain  <- createDataPartition(data$mpg, p=0.7, list=FALSE)
    training <- data[inTrain, ]
    testing  <- data[-inTrain, ]
    set.seed(12345)
    control <- trainControl(method="cv", number=3, verboseIter=FALSE)
    Mod_RF <- train(mpg ~ cyl + hp + wt + am, data=training, method="rf", trControl=control)
    Pred_RF <- predict(Mod_RF, testing)
    
    output$Pred <- renderPrint({
        paste(predict(Mod_RF, user_input()), "miles per gallon")
    })
    output$Model_RF <- renderPrint({
        Mod_RF$finalModel
    })

})
