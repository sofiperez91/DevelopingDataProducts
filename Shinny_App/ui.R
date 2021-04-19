#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shiny)
library(ggplot2)
library(plotly)
library(caret)

# Define UI for application that draws a histogram
shinyUI(
    navbarPage("Analyzing car performance",
        tabPanel("Data Analysis",
            mainPanel(
                tabsetPanel(type="tabs",
                    tabPanel("Plot",br(),
                             sidebarPanel(
                                 selectInput("var_1","Select variable x in mpg~x:", choices=c("Weight"=6,"Horse Power"=4)),
                                 selectInput("var_2","Select marker size variable:", choices=c("Cylinders"=2,"Transmission Type"=8)), 
                                 selectInput("var_3","Select color scale variable:", choices=c("Horse Power"=4,"Weight"=6,"Cylinders"=2,"Transmission Type"=8)) 
                             ),
                             mainPanel(
                        plotlyOutput("Plot_2")
                             )
                
                    ),
                    tabPanel("Regression Analysis",
                             h1("Mutivariable Linear Regression Analysis"),
                             textOutput("Summary"),
                             verbatimTextOutput("Model_1"),
                             textOutput("Step"),
                             verbatimTextOutput("Model_2"),
                             textOutput("Conclusion")
                             
                             
                    )
                )
            ),
        
        ), 
        tabPanel("Prediction",
            sidebarPanel(
                sliderInput("user_wt",
                            "Car weight:",
                            min = 1500,
                            max = 5500,
                            value = 3500,step=100),
                    sliderInput("user_hp",
                                "Horse Power:",
                                min = 50,
                                max = 350,
                                value = 200,step=10),
                checkboxGroupInput("user_cyl", "Number of cylinders:", c("4"=4,"6"=6,"8"=8),selected=4),
                checkboxGroupInput("user_am", "Transmission type", c("automatic"=0,"manual"=1),selected=0)
            ),

            mainPanel(
                tabsetPanel(type="tabs",
                    tabPanel("Plot",br(),
                        h2("The prediction for your car performance is:"),
                        h3(textOutput("Pred"))
                    ),
                    tabPanel("Prediction Model",
                        h2("Rain Forest Model"),
                        verbatimTextOutput("Model_RF")
                        
                    )
                )
            )
            ),
           tabPanel("README",mainPanel(
               includeMarkdown("README.md")
               )

          )
    )
)
