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


shinyUI(
  navbarPage(theme = shinytheme("darkly"), title=img(src="NoHate.jpeg", height = 30, width=45), id="nav", windowTitle = "Hate crime",
             tabPanel("Introduction",
                      fluidRow(
                        tags$img(src = "hate.jpeg", class = "background", height ="180%", width="100%", style = "opacity: 0.5"),
                        absolutePanel(id = "text", class = "foreground-content",
                                      top = "20%", left = "15%", right = "15%", width = "70%", fixed=FALSE,
                                      draggable = FALSE, height = 200,
                                      fluidRow(
                                        style = "padding: 8%; background-color: white",
                                        tags$h1("EndHate NYC", style="color:#20bc9c;font-weight:bold"),
                                        tags$p("While the COVID-19 pandemic caused a nationwide increase in crimes due to widespread food, housing and healthcare insecurity, it also brought a significant increase in hate crimes (notably towards Asian-Americans), with New York City reportedly experiencing a 223% increase in hate crimes in the first quarter of 2021 compared to the previous year.", style="font-weight:bold;color:#18bc9c"),
                                        tags$p("EndHate is a tool for individuals to learn more about the rise of hate crimes in NYC, and encourage them to report such events, increasing citizen engagement. This will help protect citizens, businesses and larger communities.", style="font-weight:bold;color:#18bc9c"),
                                        tags$p("The following pages provide a map view of NYC crime complaints, their correspondence to COVID hospitalizations, and reported hate crimes during the pandemic.", style="font-weight:bold;color:#18bc9c")
                                        ),
                                      style = "opacity: 0.85")
                      )),
             tabPanel("Map",
                      div(class="outer map",
                          leafletOutput("map", width="100%", height=620),
                          absolutePanel(id = "choices", class = "panel panel-default",
                                        top = 100, left = 25, width = 250, fixed=FALSE,
                                        draggable = TRUE, height = "auto",
                                        tags$h1("Please Select",
                                           align = "left", style = "font-size:30px"),
                                        selectInput("Month",
                                                    label = "Month",
                                                    choices = c('03/2020', '04/2020','05/2020','06/2020','07/2020','08/2020','09/2020','10/2020','11/2020','12/2020', '01/2021','02/2021','03/2021','04/2021', '05/2021','06/2021')
                                        ),
                                        tags$h2("Type of Crimes",
                                           align = "left",style = "font-size:15px"),
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
                                                      label = "dangerous weapons", value = FALSE),
                                        style = "opacity: 0.80")
                          )
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
             
             tabPanel("COVID and Crimes",
                      sidebarPanel(
                        selectInput("borough",
                                    label = "Borough",
                                    choices = c('Manhattan', 'Bronx', 'Queens', 'Brooklyn', 'Staten Island')
                        ),
                        selectInput("crime",
                                    label = "Type of crime",
                                    choices = tolower(c("CRIMINAL MISCHIEF & RELATED OF", "GRAND LARCENY", "BURGLARY",
                                                        "FELONY ASSAULT", "MISCELLANEOUS PENAL LAW",
                                                        "GRAND LARCENY OF MOTOR VEHICLE",
                                                        "ROBBERY", "DANGEROUS WEAPONS"))
                        )
                      ),
                      mainPanel(
                        plotOutput(outputId = "t3Plot1"),
                        plotOutput(outputId = "t3Plot2")
                      )
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
             tabPanel("Hate Crimes and COVID",
                        sidebarPanel(
                          selectInput("county",
                                      label = "borough",
                                      choices = c('Manhattan', 'Bronx', 'Queens', 'Brooklyn', 'Staten Island')
                          ),
                          selectInput("bias",
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
                        ),
                        mainPanel(
                          plotOutput(outputId = "t4Plot1"),
                          plotOutput(outputId = "t4Plot2")
                        )

             ), 
             tabPanel("Appendix",
                      fluidRow(
                        tags$img(src = "hate.jpeg", class = "background", height ="180%", width="100%", style = "opacity: 0.5"),
                        absolutePanel(id = "text", class = "foreground-content",
                                      top = "20%", left = "15%", right = "15%", width = "70%", fixed=FALSE,
                                      draggable = FALSE, height = 200,
                                      fluidRow(
                                        style = "padding: 8%; background-color: white",
                                        tags$h1("Appendix", style="color:#20bc9c;font-weight:bold"),
                                        tags$p("All data sources are from NYC Open Data. The data sources used can be found here.", style = "color;font-weight:bold"),
                                        tags$p("Made with R Shiny. Packages used include dplyr, lubridate, shinythemes, leaflet, tidyr.
This project was created as part of Columbia University's STATGR5243 Applied Data Science course.", style = "color:#18bc9c;font-weight:bold"),
                                        tags$p("Authors: Bohao Ma (Department of Statistics, Columbia University), Egem Yorulmaz (Department of Applied Mathematics, Columbia University), Qian Zhang (Department of Statistics, Columbia University),
Jiayi Nie (Columbia University).", style = "color:#18bc9c;font-weight:bold"),
                                        tags$p("Github: See the code and data sources in our Github repository at https://github.com/TZstatsADS/Fall2021-Project2-group8", style = "color:#18bc9c;font-weight:bold")
                                      ),
                                      style = "opacity: 0.85")
                      ))
  )
)