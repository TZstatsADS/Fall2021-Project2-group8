#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

ui <- 
    navbarPage("Demo", selected = "tab1", collapsible = TRUE, inverse = TRUE, theme = shinytheme("spacelab"),
               tabPanel("1"),
               tabPanel("2",
                        fluidPage(
                            tabsetPanel(
                              sidebarLayout(
                                sidebarPanel(
                                  radioButtons(
                                    inputId = "question1",
                                    label = "Choose",
                                    choices = c("a", 
                                                "b", 
                                                "c", 
                                                "d",
                                                "e")), br(),
                                  radioButtons(
                                    inputId = "group1",
                                    label = "Choose",
                                    choices = c("a", "b", "c")), br(),
                                  radioButtons(
                                    inputId = "plot1",
                                    label = "Choose",
                                    choices = c("a", "b", "c"))),
                                mainPanel(plotOutput(outputId = "plot", height = "600px"))
                                         ),
                            ))),
               tabPanel("3"), 
               tabPanel("4"),
               tabPanel("5")
    )