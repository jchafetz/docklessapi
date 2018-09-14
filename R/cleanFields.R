#' Function to clean up the data frames so that they can be combined
#'
#' @param df dataframe to clean up
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples


cleanFields <- function(df){
    #Company Name
    dfname <- deparse(substitute(df))

    df <-
        df %>%
        mutate(company = as.character(dfname))

    #Vehicle Type
    #If else statement to separate lime's bikes & scooters from the rest of companies
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
               long > -78 & long < -76) #Skip reports data nationally

    #Selecting fields we want
    df <-
        df %>%
        select(company, vehicletype, bikeID, lat, long)

    return(df)

}
