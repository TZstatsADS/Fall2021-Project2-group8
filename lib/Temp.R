packages.used=c("tidyverse")

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

# Include the functions wrote by us
# source("../lib/")
# source("../lib/")

# from 2/29/2020 to 6/30/2021
hate.crime <- read_csv("../data/NYPD_Hate_Crimes.csv")
covid <- read_csv("../data/cases-by-day.csv")
complaint <- read_csv("../data/NYPD_Complaint_Map__Year_to_Date_.csv")
shoot.his <- read_csv("../data/NYPD_Shooting_Incident_Data__Historic_.csv")
shoot.cur <- read_csv("../data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")


