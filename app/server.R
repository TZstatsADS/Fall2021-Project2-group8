library(shiny)
library(dplyr)
library(lubridate)

# Read the raw data
# covid_raw <- read.csv("./Fall2021-Project2-group8/data/cases-by-day.csv")
shoot_his_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Historic_.csv")
shoot_cur_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")

names(shoot_cur_raw)[length(names(shoot_cur_raw))]<-"Lon_Lat"
shoot_his_raw$X_COORD_CD = as.character(shoot_his_raw$X_COORD_CD)
shoot_his_raw$Y_COORD_CD = as.character(shoot_his_raw$Y_COORD_CD)

shoot = dplyr::bind_rows(shoot_his_raw, shoot_cur_raw)
shoot = shoot[!(is.na(shoot$X_COORD_CD) &!is.na(shoot$Y_COORD_CD)),]
shoot = shoot %>% arrange(mdy(shoot$OCCUR_DATE))

complaint_his_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Complaint_Map__Historic_.csv")
complaint_cur_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Complaint_Map__Year_to_Date_.csv")

complaint = dplyr::bind_rows(complaint_his_raw, complaint_cur_raw)
complaint = complaint[!(is.na(complaint$X_COORD_CD) &!is.na(complaint$Y_COORD_CD)),]
complaint = complaint %>% arrange(mdy(complaint$CMPLNT_FR_DT))


selectShoot <- function(month){
    shoot[substr(shoot$OCCUR_DATE, 4, 10) == month, ]
}


#### 02/29/2020 - 06/30/2021


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
        
        
        
        # if (input$Date == '03/2020') {
        #     leafletProxy("map", data = df_react_shoot()) %>%
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
               "a" = '',
               "b" = '',
               "c" = '')
    })
    dataInput <- reactive({
        switch(input$question1, 
               "a" = '', 
               "b" = '', 
               "c" = '', 
               switch(input$question1,
                      "a" = '',
                      "b" = '',
                      "c" = '',
                      "d" = '',
                      "e" = '')
    )})
 
}
    
   
