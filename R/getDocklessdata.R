#' Pull, clean, and save dockless API data
#'
#' @param output_filepath folder directory where you want the file to save to
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples


getDocklessdata <- function(output_filepath){

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
    df <- purrr::map2_dfr(.x = dockless_urls$company,
                          .y = dockless_urls$url,
                          .f = ~ bikeData(.x, .y) %>% cleanFields())

    #Timestamp new data and add it to data frame
    df$time <- lubridate::now()

    #Time stamp and export
    time <- format(lubridate::now(), "%Y%m%d_%H%M%S_")

    #export
    readr::write_csv(df, file.path(output_filepath, paste0(time, "docklessbike_data_set.csv")), na = "FALSE")

}
