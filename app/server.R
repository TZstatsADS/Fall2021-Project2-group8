library(shiny)
library(dplyr)
library(lubridate)

# Read the raw data
# covid_raw <- read.csv("./Fall2021-Project2-group8/data/cases-by-day.csv")

# shoot_his_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Historic_.csv")
# shoot_cur_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")
# 
# names(shoot_cur_raw)[length(names(shoot_cur_raw))]<-"Lon_Lat"
# shoot_his_raw$X_COORD_CD = as.character(shoot_his_raw$X_COORD_CD)
# shoot_his_raw$Y_COORD_CD = as.character(shoot_his_raw$Y_COORD_CD)
# 
# shoot = dplyr::bind_rows(shoot_his_raw, shoot_cur_raw)
# shoot = shoot[!(is.na(shoot$X_COORD_CD) &!is.na(shoot$Y_COORD_CD)),]
# shoot = shoot %>% arrange(mdy(shoot$OCCUR_DATE))

complaint_his_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Complaint_Map__Historic_.csv")
complaint_cur_raw <- read.csv("/Users/apple/Fall2021-Project2-group8/data/NYPD_Complaint_Map__Year_to_Date_.csv")

complaint = dplyr::bind_rows(complaint_his_raw, complaint_cur_raw)
complaint = complaint[!(is.na(complaint$Latitude) &!is.na(complaint$Longitude)),]
complaint = complaint %>% arrange(mdy(complaint$CMPLNT_FR_DT))



# cat = unique(complaint$OFNS_DESC)
# num = vector()
# 
# for (i in cat){
#     num <- c(num, sum(complaint$OFNS_DESC == i))
# }
# 
# type_crime = vector()
# 
# 
# # choose top 8 
# for (i in 1:8){
#     type_crime <- c(type_crime, cat[which.max(num)])
#     num[which.max(num)] = 0
# }




selectComplaint <- function(month, type){
    complaint[(substr(complaint$CMPLNT_FR_DT, 4, 10) == month & complaint$OFNS_DESC == type), ]
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
            addProviderTiles("CartoDB.Voyager") %>%
            setView(lng = -73.935242, lat = 40.730610, zoom = 10)
    })
    #
    #
    df_react_cm <- reactive({
        selectComplaint(input$Date,"CRIMINAL MISCHIEF & RELATED OF")
    })
    
    df_react_gl <- reactive({
        selectComplaint(input$Date,"GRAND LARCENY")
    })
    
    df_react_bu <- reactive({
        selectComplaint(input$Date,"BURGLARY")
    })
    
    df_react_fa <- reactive({
        selectComplaint(input$Date,"FELONY ASSAULT")
    })

    df_react_mpl <- reactive({
        selectComplaint(input$Date, "MISCELLANEOUS PENAL LAW")
    })
    
    df_react_glom <- reactive({
        selectComplaint(input$Date, "GRAND LARCENY OF MOTOR VEHICLE")
    })
    
    df_react_ro <- reactive({
        selectComplaint(input$Date, "ROBBERY")
    })
    
    df_react_dw <- reactive({
        selectComplaint(input$Date, "DANGEROUS WEAPONS")
    })    
       
    observe({
        leafletProxy("map", data = df) %>%
            clearShapes() %>%
            clearMarkers() %>%
            addProviderTiles("CartoDB.Voyager") %>%
            fitBounds(-74.354598, 40.919500, -73.761545, 40.520024)
    
    
        if (input$Date != '') {
            if (input$criminal_mischief){
                leafletProxy("map", data = df_react_cm()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'blue',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            } 
            
            if (input$grand_larceny){
                leafletProxy("map", data = df_react_gl()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'red',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            } 
            
            if (input$burglary){
                leafletProxy("map", data = df_react_bu()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'orange',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
            
            if (input$felony_assault){
                leafletProxy("map", data = df_react_fa()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'gold',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
            
            if (input$miscellaneous_penal_law){
                leafletProxy("map", data = df_react_mpl()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'green',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
            
            if (input$motor_vehicle){
                leafletProxy("map", data = df_react_glom()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'yellow',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
            
            if (input$robbery){
                leafletProxy("map", data = df_react_ro()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'purple',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
            
            if (input$dangerous_weapons){
                leafletProxy("map", data = df_react_dw()) %>%
                    addCircleMarkers(
                        lng=~Longitude,
                        lat=~Latitude,
                        color = 'brown',
                        stroke = FALSE,
                        fillOpacity = 0.5
                    )
            }
 
        }
    }) 
    
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
    
   
