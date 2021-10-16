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
library(leaflet)



# 02/29/2020 - 06/30/2021

shinyUI(
  navbarPage(("Demo"),
      tabPanel("Introduction",
               fluidRow(
                 tags$h1("Introduction", style="font-weight:bold"),
                 tags$h2(".......")
               )),
      tabPanel("Map",
               leafletOutput("map", width="100%", height=620),
               sidebarPanel(
                 # selectInput("Type of crime",
                 #             label = "Type of crime",
                 #             choices = c('a', 'b', 'c')
                 #             ),
                 selectInput("Date",
                             label = "Date", 
                             choices = c('03/2020', '04/2020','05/2020','06/2020','07/2020','08/2020','09/2020','10/2020','11/2020','12/2020', '01/2021','02/2021','03/2021','04/2021', '05/2021','06/2021'),
                             )
                 # selectInput("Month",
                 #             label = "Month", 
                 #             choices = c('a', 'b', 'c')
                 # )
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