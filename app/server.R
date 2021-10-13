#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

server <- function(input, output) {
    groupInput <- reactive({
        switch(input$group1,
               "a" = '', 
               "b" = '', 
               "c" = '')
    })
    dataInput <- reactive({
        switch(input$question1, 
               "a" = '', 
               "b" = '', 
               "c" = '', 
               "d" = '',
               "e" = '')
    })
    output$plot_access_web <- renderPlot({
        if (input$plot1 == "a") {

        } else if (input$plot1 == "b") {

        } else if (input$plot1 == "c") {

        }
    })
}
