packages.used=c("shiny", "dplyr", "lubridate", "shinythemes", "leaflet", "tidyr")

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
library(tidyr)


# Process COVID Data
covid_raw <- read.csv("./data/cases-by-day.csv")
covid <- covid_raw %>% select(date = date_of_interest, case = CASE_COUNT,
                                       bk = BK_CASE_COUNT, bx = BX_CASE_COUNT,
                                       mn = MN_CASE_COUNT, qn = QN_CASE_COUNT,
                                       si = SI_CASE_COUNT) %>% na.omit()
covid$date <- as_date(covid$date, format = '%m/%d/%Y')
covid <- covid %>% filter(date >= as_date("2020-03-01"), 
                          date <= as_date("2021-06-30"))
rm(covid_raw)

# Process Crime data
complaint_his_raw <- read.csv("./data/NYPD_Complaint_Map__Historic_.csv")
complaint_cur_raw <- read.csv("./data/NYPD_Complaint_Map__Year_to_Date_.csv")

complaint = dplyr::bind_rows(complaint_his_raw, complaint_cur_raw)
complaint = complaint[!(is.na(complaint$Latitude) &!is.na(complaint$Longitude)),]
complaint = complaint %>% arrange(mdy(complaint$CMPLNT_FR_DT))

# Process hate crime data
hatecrime_raw <- read.csv("./data/NYPD_Hate_Crimes.csv")
hatecrime <- hatecrime_raw[!is.na(hatecrime_raw$Record.Create.Date), ]
hatecrime %>% drop_na(Record.Create.Date)
hatecrime$County <- gsub("RICHMOND", "STATEN ISLAND", hatecrime$County)
hatecrime$County <- gsub("KINGS", "BROOKLYN", hatecrime$County)
hatecrime$County <- gsub("NEW YORK", "MANHATTAN", hatecrime$County)
hatecrime <- hatecrime %>% mutate(date = Record.Create.Date,
                                  bias = Bias.Motive.Description,
                                  borough = County)
hatecrime$date <- as_date(hatecrime$date, format = '%m/%d/%Y')
hatecrime <- hatecrime %>% filter(date >= as_date("2020-03-01"), 
                                  date <= as_date("2021-06-30"))


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
    # NYC map
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
        selectComplaint(input$Month,"CRIMINAL MISCHIEF & RELATED OF")
    })
    
    df_react_gl <- reactive({
        selectComplaint(input$Month,"GRAND LARCENY")
    })
    
    df_react_bu <- reactive({
        selectComplaint(input$Month,"BURGLARY")
    })
    
    df_react_fa <- reactive({
        selectComplaint(input$Month,"FELONY ASSAULT")
    })

    df_react_mpl <- reactive({
        selectComplaint(input$Month, "MISCELLANEOUS PENAL LAW")
    })
    
    df_react_glom <- reactive({
        selectComplaint(input$Month, "GRAND LARCENY OF MOTOR VEHICLE")
    })
    
    df_react_ro <- reactive({
        selectComplaint(input$Month, "ROBBERY")
    })
    
    df_react_dw <- reactive({
        selectComplaint(input$Month, "DANGEROUS WEAPONS")
    })    
       
    observe({
        leafletProxy("map", data = df) %>%
            clearShapes() %>%
            clearMarkers() %>%
            addProviderTiles("CartoDB.Voyager") %>%
            fitBounds(-74.354598, 40.919500, -73.761545, 40.520024)

    
        if (input$Month != '') {
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
    covid_data1 <- reactive({
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
        smooth <- ksmooth(x = covid_data1()$date,y = covid_data1()$case, kernel = "normal",
                          bandwidth = 10)
        plot(x = covid_data1()$date,y = covid_data1()$case, xaxt = "n", lty = 1,
        ylab = "daily confirmed cases", xlab = "",
        main = paste("Number of confirmed cases in",  input$borough))
        axis.Date(1, at=seq(min(covid_data1()$date), max(covid_data1()$date), by="months"), 
                  format="%m/%d/%Y")
        lines(smooth, col = "red", lwd = 2)
        legend("topright", legend=c("Trend (Kernel regression)"),
               col=c("red"), lty=1, lwd=2)
    })
    output$t3Plot2 <- renderPlot({
        # Kernel regression to smooth the plots
        smooth <- ksmooth(x = crime_data()$date, y = crime_data()$n, kernel = "normal",
                          bandwidth = 10)
        plot(x = crime_data()$date, y = crime_data()$n, xaxt = "n",
             ylab = "daily number of crimes", xlab = "",
             main = paste("Number of", input$crime, "in",  input$borough))
        axis.Date(1, at=seq(as_date("2020-03-01"), as_date("2021-06-30"), by="months"), 
                  format="%m/%d/%Y")
        lines(smooth, col = "red", lwd = 2)
        legend("topright", legend=c("Trend (Kernel regression)"),
               col=c("red"), lty=1, lwd=2)
    })

    
    #########TAB 4 HATE CRIMES AND COVID###############
    TypeofHate <- c("ANTI-JEWISH", "ANTI-ASIAN", "ANTI-MALE HOMOSEXUAL (GAY)",
                    "ANTI-BLACK", "ANTI-WHITE",
                    "ANTI-TRANSGENDER",
                    "ANTI-MUSLIM", "ANTI-CATHOLIC", "ANTI-OTHER ETHNICITY", "ANTI-FEMALE",
                    "ANTI-HISPANIC", "ANTI-LGBT (MIXED GROUP)", "ANTI-FEMALE HOMOSEXUAL (LESBIAN)",
                    "ANTI-ARAB", "ANTI-GENDER NON-CONFORMING", "ANTI-MULTI-RACIAL GROUPS",
                    "ANTI-OTHER RELIGION", "ANTI-BUDDHIST", "ANTI-HINDU", "ANTI-RELIGIOUS PRACTICE GENERALLY",
                    "60 YEARS AND OLDER", "ANTI-JEHOVAHS WITNESS", "ANTI-PHYSICAL DISABILITY")
    County <- c('BROOKLYN', 'MANHATTAN', 'QUEENS', 'BRONX', 'STATEN ISLAND')
    
    covid_data <- reactive({
      if('Manhattan' %in% input$county){
        return(covid %>% select(date, case = mn)) 
      }
      if('Bronx' %in% input$county){
        return(covid %>% select(date, case = bx))
      }
      if('Queens' %in% input$county){
        return(covid %>% select(date, case = qn))
      }
      if('Brooklyn' %in% input$county){
        return(covid %>% select(date, case = bk))
      }
      if('Staten Island' %in% input$county){
        return(covid %>% select(date, case = si))
      }
    })
    
    hate_data <- reactive({
      for (x in 1:length(County)){
        for(y in 1:length(TypeofHate)){
          if(toupper(input$county) %in% County[x] & toupper(input$bias) %in% TypeofHate[y]){
            
            temp2 <- hatecrime %>% filter(borough == toupper(input$county),
                                          bias == TypeofHate[y]) %>% group_by(date) %>% count()
            
            temp2$date <- as_date(temp2$date, format = '%m/%d/%Y')
            
            temp3 <- temp2
            
            
            return(temp2)
          }
        }
      }
    })
    
    #    hate_data()$date %>% 
    #      group_by(month = lubridate::floor_date(date, "month")) %>%
    #      summarize(summary_variable = sum(value))
    
    #   View(hate_data()$date)
    
    output$t4Plot1 <- renderPlot({
      # Kernel regression to get a smooth trend
      smooth <- ksmooth(x = covid_data()$date,y = covid_data()$case, kernel = "normal",
                        bandwidth = 10)
      plot(x = covid_data()$date,y = covid_data()$case, xaxt = "n", lty = 1,
           ylab = "daily confirmed cases", xlab = "",
           main = paste("Number of confirmed cases in",  input$county))
      axis.Date(1, at=seq(min(covid_data()$date), max(covid_data()$date), by="months"), 
                format="%d-%m-%Y")
      lines(smooth, col = "red", lwd = 2)
      legend("topright", legend=c("Trend (Kernel regression)"),
             col=c("red"), lty=1, lwd=2)
    })
    
    output$t4Plot2 <- renderPlot({
      # Kernel regression to smooth the plots
      #smooth <- ksmooth(x = hate_data()$date, y = hate_data()$n, kernel = "box",
      #                  bandwidth = 5)
      #print(hate_data()$date)
      plot(x = hate_data()$date, y = hate_data()$n, ylim=c(0,max(hate_data()$n)),
           #plot(x = temp2$date, y = temp2$n,
           ylab = "daily number of hate crimes", xlab = "", xaxt = "n",
           main = paste("Number of", input$bias, "hate crimes in",  input$county))
      #axis.Date(1, at=seq(min(hate_data()$date), max(hate_data()$date), by="months"), 
      #format="%d-%m-%Y")
      axis.Date(1, at=seq(as_date("2020-03-01"), as_date("2021-06-30"), by="months"), 
                format="%d-%m-%Y")
      #lines(smooth, col = "red", lwd = 2)
      #legend("topright", legend=c("Kernel regression"),
      #       col=c("red"), lty=1, lwd=2)
    })
    
    
 
}
    
   
