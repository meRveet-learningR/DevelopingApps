#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(HistData)
data(GaltonFamilies)
library(dplyr)
library(ggplot2)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Height of the Child, Prediction from Parent's Height."),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            helpText("Prediction based on Parent's Height Input"),
            helpText("Inputs Variables"),
            sliderInput(inputId= "iFH",
                        label= "Father's Height (cm)",
                        value= min(x$father),
                        min = min(x$father),
                        max = max(x$father),
                        step = 1),
            sliderInput(inputId= "iMH",
                        label= "Mother's Height(cm)",
                        value= min(x$mother),
                        min = min(x$mother),
                        max = max(x$mother),
                        step= 1),
            radioButtons(inputId= "iG",
                         label= "Child's Gender",
                         choices= c("Female"="female", "Male"= "male"),
                         inline=T)
        ),
        # Show a plot of the generated distribution
        mainPanel(
            htmlOutput("parents"),
            htmlOutput("pred"),
            plotOutput("Plot", width="50%")
        )
    )
))
