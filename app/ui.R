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

shinyUI(
  navbarPage(("Demo"),
      tabPanel("Introduction",
               fluidRow(
                 tags$h1("Introduction", style="font-weight:bold"),
                 tags$h2(".......")
               )),
      tabPanel("Map",
               sidebarPanel(
                 selectInput("Type of crime",
                             label = "Type of crime",
                             choices = c('a', 'b', 'c')
                             ),
                 sliderInput("Date",
                             label = "Date", 
                             min = 0, 
                             max = 100, 
                             value = 50
                             )
               )),
      tabPanel("Plots",
               sidebarPanel(
                 selectInput("NYC borough",
                             label = "borough",
                             choices = c('a', 'b', 'c')
                 ),
                 selectInput("Type of crime",
                             label = "Type of crime",
                             choices = c('a', 'b', 'c')
                 ),
               checkboxInput("lockdown", label = "lockdown", value = TRUE),  
               checkboxInput("reopen", label = "reopen", value = FALSE)
               )),
        tabPanel("Plots",
                 sidebarPanel(
                   selectInput("Bias motivated",
                               label = "bias",
                               choices = c('a', 'b', 'c')
                   ),
                   selectInput("NYC borough",
                               label = "borough",
                               choices = c('a', 'b', 'c')
                   ),
                   selectInput("Seriousness",
                               label = "seriouness",
                               choices = c('a', 'b', 'c')
                   ),
                   checkboxInput("lockdown", label = "lockdown", value = TRUE),  
                   checkboxInput("reopen", label = "reopen", value = FALSE)
                 )
                 ), 
        tabPanel("Appendix"))
)