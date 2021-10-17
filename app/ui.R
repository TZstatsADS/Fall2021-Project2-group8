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
               sidebarPanel(
                 h1("Please select", 
                    align = "left"),
                 selectInput("Date",
                             label = "Date", 
                             choices = c('03/2020', '04/2020','05/2020','06/2020','07/2020','08/2020','09/2020','10/2020','11/2020','12/2020', '01/2021','02/2021','03/2021','04/2021', '05/2021','06/2021') 
                             ),
                 h2("Please select", 
                    align = "left"),
                 checkboxInput("criminal_mischief", 
                               label = "criminal mischief", value = FALSE),
                 checkboxInput("grand_larceny", 
                             label = "grand larceny", value = FALSE),
                 checkboxInput("burglary", 
                             label = "burglary", value = FALSE),
                 checkboxInput("felony_assault", 
                             label = "felony assault", value = FALSE),
                 checkboxInput("miscellaneous_penal_law", 
                             label = "miscellaneous penal law", value = FALSE),
                 checkboxInput("motor_vehicle", 
                             label = "grand larceny of motor vehicle", value = FALSE),
                 checkboxInput("robbery", 
                             label = "robbery", value = FALSE),
                 checkboxInput("dangerous_weapons", 
                             label = "dangerous weapons", value = FALSE)
                ),
               mainPanel(leafletOutput("map", width="100%", height=620))
               ),
                 
                 #"CRIMINAL MISCHIEF & RELATED OF"
                 # "GRAND LARCENY"
                 #  "BURGLARY"
                 # "FELONY ASSAULT"
                 # "MISCELLANEOUS PENAL LAW"
                 # "GRAND LARCENY OF MOTOR VEHICLE"
                 #  "ROBBERY"
                 #  "DANGEROUS WEAPONS"
                 
                 # selectInput("Month",
                 #             label = "Month", 
                 #             choices = c('a', 'b', 'c')
                 # )
              
      tabPanel("Plots",
               sidebarPanel(
                 selectInput("NYC borough",
                             label = "borough",
                             choices = c('Manhattan', 'Bronx', 'Queens', 'Brooklyn', 'Staten Island')
                 ),
                 selectInput("Type of crime",
                             label = "Type of crime",
                             choices = c('criminal mischief', 'grand larceny', 'burglary', "felony assault", "miscellaneous penal law", "grand larceny of motor vehicle", "robbery", "dangerous_weapons")
                 )
               # checkboxInput("lockdown", label = "lockdown", value = FALSE),  
               # checkboxInput("reopen", label = "reopen", value = FALSE)
               ),
               mainPanel()
               ),
      # [1] "ANTI-MALE HOMOSEXUAL (GAY)"        "ANTI-WHITE"                       
      # [3] "ANTI-MUSLIM"                       "ANTI-HISPANIC"                    
      # [5] "ANTI-TRANSGENDER"                  "ANTI-JEWISH"                      
      # [7] "ANTI-ASIAN"                        "ANTI-BLACK"                       
      # [9] "ANTI-FEMALE HOMOSEXUAL (LESBIAN)"  "ANTI-ARAB"                        
      # [11] "ANTI-CATHOLIC"                     "ANTI-GENDER NON-CONFORMING"       
      # [13] "ANTI-FEMALE"                       "ANTI-LGBT (MIXED GROUP)"          
      # [15] "ANTI-MULTI-RACIAL GROUPS"          "ANTI-OTHER ETHNICITY"             
      # [17] "60 YRS AND OLDER"                  "ANTI-HINDU"                       
      # [19] "ANTI-BUDDHIST"                     "ANTI-JEHOVAHS WITNESS"            
      # [21] "ANTI-PHYSICAL DISABILITY"          "ANTI-OTHER RELIGION"              
      # [23] "ANTI-RELIGIOUS PRACTICE GENERALLY"
        tabPanel("Plots",
                 sidebarPanel(
                   
                   selectInput("NYC borough",
                               label = "borough",
                               choices = c('Manhattan', 'Bronx', 'Queens', 'Brooklyn', 'Staten Island')
                   ),
                   selectInput("Bias motivated",
                               label = "bias",
                               choices = c('Anti-male homosexual (gay)', 
                                           "Anti-White", 'Anti-Muslim', 'Anti-Hispanic', 
                                           'Anti-transgender', 'Anti-Jewish', 'Anti-Asian', 
                                           'Anti-Black', 'Anti-female homosexual (lesbian)',
                                           'Anti-Arab', 'Anti-Catholic', 'Anti-gender non-conforming',
                                           'Anti-female', 'Anti-LGBT (mixed group)', 'Anti-multi-racial group',
                                           'Anti-other ethnicity', '60 yrs and older', 'Anti-Hindu', 
                                           'Anti-Buddhist', 'Anti-Jehovahs Witness', 'Anti-physical disability',
                                           'Anti-other religion', 'Anti-religious practice generally')
                   )
                   # selectInput("Seriousness",
                   #             label = "seriouness",
                   #             choices = c('a', 'b', 'c')
                   # )
                   # checkboxInput("lockdown", label = "lockdown", value = FALSE),  
                   # checkboxInput("reopen", label = "reopen", value = FALSE)
                   ),
                  mainPanel()
                 ), 
        tabPanel("Appendix"))
)