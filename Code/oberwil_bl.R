# https://www.neubauprojekte.ch/listing/kaufen-mieten/basel-landschaft/oberwil-bl/neubau-mehrfamilienhaeuser-mit-autoeinstellhalle-9/

library(rvest)
library(dplyr)
library(stringr)
# Read the URL of the website into R
url <- "https://www.neubauprojekte.ch/listing/kaufen-mieten/basel-landschaft/oberwil-bl/neubau-mehrfamilienhaeuser-mit-autoeinstellhalle-9/"
webpage <- read_html(url)

# Adress:
adress <- "Hohlweg , 4104, Oberwil BL"

# Use html_nodes to extract the elements with class "list scroll"
houses <- html_nodes(webpage, ".px-3") %>% html_text()
houses

# assume that 'houses' is the name of your list of house listings

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
house_data$adress <- rep(adress)
