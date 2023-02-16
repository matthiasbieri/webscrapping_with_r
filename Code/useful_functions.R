library(rvest)
library(stringr)

get_address <- function(url) {
  webpage <- read_html(url)
  adress <- webpage %>% html_nodes(".xl\\:mb-5") %>%  html_text() 
  adress <- adress[2]
  adress <- trimws(adress)
  return(adress)
}


get_house_data <- function(url, address) {
  # Read the URL of the website into R
  webpage <- read_html(url)
  
  # Use html_nodes to extract the elements with class "list scroll"
  houses <- html_nodes(webpage, ".px-3") %>% html_text()
  
  # extract number of rooms from each string
  rooms <- gsub(".*?(\\d+\\.\\d+)\\s*Zimmer.*", "\\1", houses)
  
  # extract size of flat from each string
  sizes <- gsub(".*?(\\d+)\\s*m².*", "\\1", houses)
  
  # extract price from each string
  prices <- gsub(".*?(CHF\\s*[\\d\\'\\.]+).*", "\\1", houses)
  # remove any apostrophes from the price strings
  prices <- gsub("'", "", prices)
  prices <- stringr::str_extract(prices, "(?<=CHF\\s)[\\d\\.]+")
  
  # combine the results into a data frame
  house_data <- data.frame(rooms, sizes, prices)
  house_data$address <- rep(address, length(houses))
  
  return(house_data)
}


url <- "https://www.neubauprojekte.ch/listing/kaufen-mieten/basel-landschaft/oberwil-bl/neubau-mehrfamilienhaeuser-mit-autoeinstellhalle-9/"
address <- get_address(url)
address

house_data <- get_house_data(url, address)
house_data
