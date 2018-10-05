#' Check API and then pull data
#'
#' @param company dockless bike company, eg "spin"
#' @param url api url
#' @param auth if authorization is required, default = NA
#'
#' @importFrom dplyr %>%
#' @export
#'


executeAPI <- function(company, url, auth = NA) {
    #Adjustments to make it easier to work with use with purr::map()
    if(company == "lime") auth  <- "Bearer limebike-PMc3qGEtAAXqJa"

    #ensure company API is running
    status <- tryCatch(
        httr::GET(url, httr::timeout(60), httr::add_headers(Authorization = paste(auth))),
        error = function(e) e
    )

    #if API is working, pull down data and munge
    if(inherits(status,  "error") == FALSE) {
        df <- bikeData(company, url) %>%
            cleanFields()
    }
}
