#' Function to pull data from the API
#'
#' @param url api url
#' @param layer list layer, eg data
#' @param auth if authorization is requireed
#'
#' @export
#' @importFrom dplyr %>%
#'
#' @examples


bikeData <- function(url, layer, auth){

    #Pull the JSON
    json <- url %>%
        httr::GET(httr::timeout(60), httr::add_headers(Authorization = paste(auth))) %>%
        httr::content("text") %>%
        jsonlite::fromJSON(flatten = TRUE)

    #extract key elements
    df <- purrr::pluck(json, layer) %>%
        as.data.frame()

    #Return dataframe
    return(df)
}
