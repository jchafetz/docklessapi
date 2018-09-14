#Putting together the data
getDocklessdata <- function(){

    #Set the urls
    dockless_urls <-
        tibble::tribble(
            ~company,                                                                         ~url,  ~layer,                            ~auth,
            "skip", "https://us-central1-waybots-production.cloudfunctions.net/dcFreeBikeStatus", "bikes",                               NA,
            "spin",                           "https://web.spin.pm/api/gbfs/v1/free_bike_status",  "data",                               NA,
            "bird",                                      "https://dzn9sy8hnh1q4.cloudfront.net/",  "data",                               NA,
            "jump",                 "https://dc.jumpmobility.com/opendata/free_bike_status.json",  "data",                               NA,
            "lime",    "https://lime.bike/api/partners/v1/bikes?region=Washington%20DC%20Proper",  "data", "Bearer limebike-PMc3qGEtAAXqJa"
        )

    #Pull the data
    currentData <- purrr::map2_dfr(.x = dockless_urls$company,
                                   .y = dockless_urls$url,
                                   .f = ~ bikeData(.x, .y) %>% cleanFields())

    #Timestamp new data and add it to data frame
    currentData$time <- now()

    return(currentData)
}
