#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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

# Converting measurements into metrics
x<- GaltonFamilies
x<- x %>% mutate(father=father*2.54, mother= mother*2.54, childHeight= childHeight*2.54)

#Model for Height 
mod<- lm(childHeight~father+mother+gender ,data=x)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$parents<- renderText({
        paste("Father's height is", round(input$iFH, 1), "cm, and mother's height is", round(input$iMH), "cm. Children")
    })
    output$pred<- renderText({
        df<- data.frame(father=input$iFH, mother=input$iMH, gender=factor(input$iG, levels= levels(x$gender)))
        predch<- predict(mod, newdata=df)
        gen<- ifelse(
            input$iG=="female", "Daughter", "Son"
        )
        paste(gen, "'s predicted height is ", round(predch,1), " cm")
    })
    output$Plot<- renderPlot({
        gen<- ifelse(
            input$iG=="female", "Daughter", "Son"
        )
        df<- data.frame(father=input$iFH, mother=input$iMH, gender=factor(input$iG, levels= levels(x$gender)))
        predch<- predict(mod, newdata=df)
        z <- c("Father", gen, "Mother")
        df<- data.frame(a= factor(z, levels=z,ordered=T), b= c(input$iFH, predch, input$iMH))
        ggplot(df,aes(x=a, y=b, color=c("Grey", "green", "black"), fill=c("Grey", "green", "black"))) +
            geom_bar(stat="identity", width=0.5) +
            xlab("") +
            ylab("Height (cm)") +
            theme_minimal() +
            theme(legend.position="none")
    })
})
