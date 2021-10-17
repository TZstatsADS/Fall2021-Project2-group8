packages.used=c("shiny", "dplyr", "lubridate", "shinythemes", "leaflet")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
    install.packages(packages.needed, dependencies = TRUE)
}

# load packages
library(shiny)
library(dplyr)
library(lubridate)

# Read the raw data
covid_raw <- read.csv("../data/cases-by-day.csv")
covid <- covid_raw %>% select(date = date_of_interest, case = CASE_COUNT,
                                       bk = BK_CASE_COUNT, bx = BX_CASE_COUNT,
                                       mn = MN_CASE_COUNT, qn = QN_CASE_COUNT,
                                       si = SI_CASE_COUNT)
# Select the rows from 2020-3-01 to 2021-6-30
covid$date <- as_date(covid$date, format = '%m/%d/%Y')
covid <- covid %>% filter(date >= as_date("2020-03-01"), 
                          date <= as_date("2021-06-30"))
rm(covid_raw)

# shoot_his_raw <- read.csv("../data/NYPD_Shooting_Incident_Data__Historic_.csv")
# shoot_cur_raw <- read.csv("../data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")
# 
# names(shoot_cur_raw)[length(names(shoot_cur_raw))]<-"Lon_Lat"
# shoot_his_raw$X_COORD_CD = as.character(shoot_his_raw$X_COORD_CD)
# shoot_his_raw$Y_COORD_CD = as.character(shoot_his_raw$Y_COORD_CD)
# 
# shoot = dplyr::bind_rows(shoot_his_raw, shoot_cur_raw)
# shoot = shoot[!(is.na(shoot$X_COORD_CD) &!is.na(shoot$Y_COORD_CD)),]
# shoot = shoot %>% arrange(mdy(shoot$OCCUR_DATE))

complaint_his_raw <- read.csv("../data/NYPD_Complaint_Map__Historic_.csv")
complaint_cur_raw <- read.csv("../data/NYPD_Complaint_Map__Year_to_Date_.csv")

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
    
    ################ Tab 2 Interactive Maps ###################
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
    
    ################## Tab 3 Crimes and COVID ##########################
    TypeofCrime <- c("CRIMINAL MISCHIEF & RELATED OF", "GRAND LARCENY", "BURGLARY",
                     "FELONY ASSAULT", "MISCELLANEOUS PENAL LAW",
                     "GRAND LARCENY OF MOTOR VEHICLE",
                     "ROBBERY", "DANGEROUS WEAPONS")
    Borough <- c('Manhattan', 'Bronx', 'Queens', 'Brooklyn', 'Staten Island')
    covid_data <- reactive({
        if('Manhattan' %in% input$borough){
            return(covid %>% select(date, case = mn)) 
        }
        if('Bronx' %in% input$borough){
            return(covid %>% select(date, case = bx))
        }
        if('Queens' %in% input$borough){
            return(covid %>% select(date, case = qn))
        }
        if('Brooklyn' %in% input$borough){
            return(covid %>% select(date, case = bk))
        }
        if('Staten Island' %in% input$borough){
            return(covid %>% select(date, case = si))
        }
    })
    crime_data <- reactive({
        for (i in 1:length(Borough)){
            for(j in 1:length(TypeofCrime)){
                if(input$borough %in% Borough[i] & input$crime %in% tolower(TypeofCrime[j])){
                    temp <- complaint %>% filter(BORO_NM == toupper(Borough[i]),
                                                 OFNS_DESC == TypeofCrime[j]) %>%
                        group_by(CMPLNT_FR_DT) %>% count()
                    temp$date <- as_date(temp$CMPLNT_FR_DT, format = '%m/%d/%Y')
                    return(temp)
                }
            }
        }
    })
    
    output$t3Plot1 <- renderPlot({
        # Kernel regression to get a smooth trend
        smooth <- ksmooth(x = covid_data()$date,y = covid_data()$case, kernel = "normal",
                          bandwidth = 5)
        plot(x = covid_data()$date,y = covid_data()$case, xaxt = "n", lty = 1,
        ylab = "daily confirmed cases", xlab = "",
        main = paste("Number of confirmed cases in",  input$borough))
        axis.Date(1, at=seq(min(covid_data()$date), max(covid_data()$date), by="months"), 
                  format="%d-%m-%Y")
        lines(smooth, col = "red", lwd = 2)
        legend("topright", legend=c("Kernel regression"),
               col=c("red"), lty=1, lwd=2)
    })
    output$t3Plot2 <- renderPlot({
        # Kernel regression to smooth the plots
        smooth <- ksmooth(x = crime_data()$date, y = crime_data()$n, kernel = "normal",
                          bandwidth = 5)
        plot(x = crime_data()$date, y = crime_data()$n,
             ylab = "daily number of crimes", xlab = "",
             main = paste("Number of", input$crime, "in",  input$borough))
        axis.Date(1, at=seq(min(crime_data()$date), max(crime_data()$date), by="months"), 
                  format="%d-%m-%Y")
        lines(smooth, col = "red", lwd = 2)
        legend("topright", legend=c("Kernel regression"),
               col=c("red"), lty=1, lwd=2)
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
    
   
