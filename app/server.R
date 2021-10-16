#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(lubridate)

# Read the raw data
# covid_raw <- read.csv("./Fall2021-Project2-group8/data/cases-by-day.csv")
shoot.his_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Historic_.csv")
shoot.cur_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")
### Clean the Shooting crime data
# # Select the columns
shoot.cur <- shoot.cur_raw %>%
    select(date = OCCUR_DATE, boro = BORO,
           x_cood = X_COORD_CD, y_cood = Y_COORD_CD,
           latitude = Latitude, longitude = Longitude,
           lon_lat = New.Georeferenced.Column)
shoot.his <- shoot.his_raw %>%
    select(date = OCCUR_DATE, boro = BORO,
           x_cood = X_COORD_CD, y_cood = Y_COORD_CD,
           latitude = Latitude, longitude = Longitude,
           lon_lat = Lon_Lat)
# Combine historical and current data

shoot <- rbind(shoot.his, shoot.cur) %>% na.omit()

shoot = shoot %>% arrange(mdy(shoot$date))

selectshoot <- function(df, month){
    df$date <- substr(df$date, 4, 10)
    df[df$date == month, ]
}


#### 02/29/2020 - 06/30/2021


### 2020, MAR-June

server <- function(input, output) {

    # pal <- colorFactor(c("navy", "red"))
    # NYC basemap
    output$map <- renderLeaflet({
        leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
            htmlwidgets::onRender(
                "function(el, x) {
                    L.control.zoom({ position: 'bottomright' }).addTo(this)
                }"
            ) %>%
            addProviderTiles("CartoDB.Positron") %>%
            setView(lng = -73.935242, lat = 40.730610, zoom = 10)
    })
    #
    #
    df_react_shoot <- reactive({
        selectshoot(shoot, input$Date)

    })
    
    
    
    observe({
        
        leafletProxy("map", data = df) %>%
            clearShapes() %>%
            clearMarkers() %>%
            addProviderTiles("CartoDB.Positron") %>%
            fitBounds(-74.354598, 40.919500, -73.761545, 40.520024)
        
        # if (is.null(input$Date)) {
        #     leafletProxy("map", data = selectshoot(shoot, '03/2020')) %>%
        #         addCircleMarkers(
        #             lng=~longitude,
        #             lat=~latitude,
        #             # radius = ~ifelse(type == "ship", 6, 10),
        #             # color = ~pal(type),
        #             stroke = FALSE,
        #             fillOpacity = 0.5
        #         )
        #     # addAwesomeMarkers(~longitude, ~latitude,
        #     #                   icon=, label=~name, popup=~content)
        #     
        # }

        
            
        if (input$Date == '03/2020') {
            leafletProxy("map", data = df_react_shoot()) %>%
                addCircleMarkers(
                    lng=~longitude,
                    lat=~latitude,
                    # radius = ~ifelse(type == "ship", 6, 10),
                    # color = ~pal(type),
                    stroke = FALSE,
                    fillOpacity = 0.5
                )
            # addAwesomeMarkers(~longitude, ~latitude,
            #                   icon=, label=~name, popup=~content)

        }
    }) 

    # FilterPoints <- function(ds) {
    #     result <- shoot %>% dplyr::filter(borough == input$plot_borough)
    #     return(result)
    # }
    # FreeMeals_reactive <- reactive({FilterPoints(FreeMeals)})
    # AdultExerciseEquip_reactive <- reactive({FilterPoints(AdultExerciseEquip)})
    # Playgrounds_reactive <- reactive({FilterPoints(Playgrounds)})
    # #Playgrounds_reactive <- reactive({
    # #   Playgrounds %>% dplyr::filter(borough == input$plot_borough)
    # #})
    #

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
