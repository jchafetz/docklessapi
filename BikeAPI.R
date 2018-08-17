# 1. SET UP ---------------------------------------------------------------
library(easypackages)
libraries("tidyverse", "jsonlite", "rjson", "httr", "RJSONIO", "gdata", "ggmap", "lubridate")

mapTheme <- function(base_size = 12){
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )
}

BaseMap <- ggmap(get_map(location = "Washington, DC", zoom = 12, maptype = "toner"))

DowntownMap <- ggmap(get_map(location = "Washington, DC", zoom = 14, maptype = "toner"))


# 2. PULL THE DATA ----------------------------------------

#Set URLs
  skipurl <- "https://us-central1-waybots-production.cloudfunctions.net/dcFreeBikeStatus" #bikes
  spinurl <- "https://web.spin.pm/api/gbfs/v1/free_bike_status" #data
  birdurl <- "https://dzn9sy8hnh1q4.cloudfront.net/" #data
  jumpurl <- "https://dc.jumpmobility.com/opendata/free_bike_status.json" #data
  limeurl <- "https://lime.bike/api/partners/v1/bikes?region=Washington%20DC%20Proper"
  
#Function to pull data from the API  
  bikeData <- function(url, layer, auth){
  
  #Pull the JSON
    json <- url %>%
            httr::GET(httr::timeout(60), add_headers(Authorization = paste(auth))) %>% 
            httr::content("text") %>% 
            jsonlite::fromJSON(flatten = TRUE) 
    
  #extract key elements
    df <- purrr::pluck(json, layer) %>%
          as.data.frame()
    
  #Return dataframe
    return(df)
}

#Function to clean up the data frames so that they can be combined
  cleanFields <- function(df){
  #Company Name
    dfname <- deparse(substitute(df))
    
    df <- 
      df %>% 
      mutate(company = as.character(dfname))
    
  #Vehicle Type
    #Now deal with the rest of the company's types
    if("attributes.vehicle_type" %in% colnames(df)){
      df <- 
        df %>% 
        rename(vehicletype = attributes.vehicle_type)
    }
    else{
      df <- 
        df %>% 
        mutate(
          vehicletype = case_when(
            company == "jump" ~ "bike",
            company == "spin" ~ "bike",
            company == "bird" ~ "scooter",
            company == "skip" ~ "scooter"
          ))
      
    }

  #BikeID
    name_ID <- 
      df %>% 
      select(matches("bike_id|bikes.bike_id|attributes.plate_number")) %>% 
      names()
    
    df <- 
      df %>% 
      rename(bikeID = name_ID)
  
  #Longtitude & Latitude
    name_long <- 
      df %>% 
      select(matches("lon|lng")) %>% 
      names()

    name_lat <- 
      df %>% 
      select(matches("lat|latitude")) %>% 
      names()
    
    df <- 
      df %>% 
      rename(lat = name_lat,
             long = name_long) %>% 
      mutate(lat = as.numeric(lat),
             long = as.numeric(long)) %>% 
      filter(lat > 37 & lat < 39, 
             long > -78 & long < -76)
             
  #Selecting Fields
    df <- 
      df %>% 
      select(company, vehicletype, bikeID, lat, long)
    
  return(df)
  
}

#Putting together the data
  allData <- data.frame()
  
  getDocklessdata <- function(){
    
  #Pull the data  
    skip <- cleanFields(bikeData(skipurl, "bikes", NA))
    jump <- cleanFields(bikeData(jumpurl, "data", NA))
    spin <- cleanFields(bikeData(spinurl, "data", NA))
    bird <- cleanFields(bikeData(birdurl, "data", NA))
    lime <- cleanFields(bikeData(limeurl, "data", "Bearer limebike-PMc3qGEtAAXqJa"))
  
  currentData <- rbind(skip, jump, spin, bird, lime)
  
  currentData$time <- now()
  
  allData <- rbind(allData, currentData)
  
  return(allData)
  }


