#' Function to pull data from the API
#'
#' @param company dockless bike company, eg "spin"
#' @param url api url
#' @param layer list layer, default = "data"
#' @param auth if authorization is required, default = NA
#'
#' @export
#' @importFrom dplyr %>%
#'


bikeData <- function(company, url, layer = "data", auth = NA){

    #Adjustments to make it easier to work with use with purr::map()
    if(company == "skip") layer <- "bikes"
    if(company == "lime") auth  <- "Bearer limebike-PMc3qGEtAAXqJa"

    #Pull the JSON
    suppressMessages(
    json <- url %>%
        httr::GET(httr::timeout(60), httr::add_headers(Authorization = paste(auth))) %>%
        httr::content("text") %>%
        jsonlite::fromJSON(flatten = TRUE)
    )
    #extract key elements
    df <- purrr::pluck(json, layer) %>%
        as.data.frame()

    #add company name
    df <- df %>%
        dplyr::mutate(company = company) %>%
        dplyr::select(company, dplyr::everything())

    #Return dataframe
    return(df)
}
