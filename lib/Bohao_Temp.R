packages.used=c("tidyverse", "lubridate")

# check packages that need to be installed.
packages.needed=setdiff(packages.used, 
                        intersect(installed.packages()[,1], 
                                  packages.used))
# install additional packages
if(length(packages.needed)>0){
  install.packages(packages.needed, dependencies = TRUE)
}

# load packages
library("tidyverse")
library("lubridate")

# Read the raw data
covid_raw <- read_csv("../data/cases-by-day.csv")
shoot.his_raw <- read_csv("../data/NYPD_Shooting_Incident_Data__Historic_.csv")
shoot.cur_raw <- read_csv("../data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")

### Clean the COVID data
# Choose the columns
covid <- covid_raw %>% select(date = date_of_interest, case = CASE_COUNT,
                          bk = BK_CASE_COUNT, bx = BX_CASE_COUNT,
                          mn = MN_CASE_COUNT, qn = QN_CASE_COUNT,
                          si = SI_CASE_COUNT)
# Select the rows from 2020-2-29 to 2021-6-30
covid$date <- as_date(covid$date, format = '%m/%d/%Y')
covid <- covid %>% filter(date <= as_date("2021-06-30"))
rm(covid_raw)

### Clean the Shooting crime data
# Select the columns
shoot.cur <- shoot.cur_raw %>%
  select(date = OCCUR_DATE, boro = BORO, 
         x_cood = X_COORD_CD, y_cood = Y_COORD_CD, 
         latitude = Latitude, longitude = Longitude,
         lon_lat = `New Georeferenced Column`)
shoot.his <- shoot.his_raw %>%
  select(date = OCCUR_DATE, boro = BORO, 
         x_cood = X_COORD_CD, y_cood = Y_COORD_CD, 
         latitude = Latitude, longitude = Longitude,
         lon_lat = Lon_Lat)
# Combine historical and current data
shoot <- rbind(shoot.cur, shoot.his) %>% na.omit()
shoot$date <- as_date(shoot$date, format = '%m/%d/%Y')
# Select the rows from 2020-2-29 to 2021-6-30
shoot <- shoot %>% filter(date <= as_date("2021-06-30")) %>%
  filter(date >= as_date("2020-02-29")) %>% arrange(date)
rm(shoot.cur, shoot.his, shoot.his_r aw, shoot.cur_raw)

selectshoot <- function(df, month){
  df$date <- substr(df$date, 4, 10)
  df[df$date == month]
}

