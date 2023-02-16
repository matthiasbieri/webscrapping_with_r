# Load required libraries
library(rvest)
library(stringr)

# Set base URL and extract the number of pages
#base_url <- "https://www.neubauprojekte.ch/listing/?alternate=true&exclusive=false&ignoreToplisting=false&mainCategory=apartment_and_house&numberOfRoomsFrom=0&numberOfRoomsTo=10&offerType=rent&orderBy=created&order=desc&priceFrom=0&priceTo=8000&radius=5&surfaceLivingFrom=0&surfaceLivingTo=300&type=all"
base_url <- "https://www.neubauprojekte.ch/kaufen/?alternate=true&exclusive=false&ignoreToplisting=false&mainCategory=apartment_and_house&numberOfRoomsFrom=0&numberOfRoomsTo=10&offerType=sale&orderBy=created&order=desc&page=1&priceFrom=0&priceTo=25000000&radius=5&surfaceLivingFrom=0&surfaceLivingTo=300&type=all"
webpage <- read_html(base_url)
num_pages <- 866

# Create an empty vector to store the links
links <- c()

# Loop through all the pages and extract the links
for (i in 1:num_pages) {
  # Construct the URL for the current page
  page_url <- paste0(base_url, "&page=", i)
  
  # Read the webpage and extract the links
  webpage <- read_html(page_url)
  page_links <- html_nodes(webpage, "a") %>% html_attr("href")
  
  # Filter the links to keep only the ones starting with "/listing/mieten/"
  #page_links <- page_links[str_detect(page_links, "^/listing/mieten/")]
  page_links <- page_links[str_detect(page_links, "^/listing/kaufen/")]
  
  # Add the filtered links to the global list of links
  links <- c(links, page_links)
  
  # Sleep for a random time between 1 and 6 seconds
  sleep_time <- runif(1, min = 0, max = 6)
  cat(paste0("Finished scraping page ", i, ", sleeping for ", sleep_time, " seconds...\n"))
  Sys.sleep(sleep_time)
}

# Unfortunatly my R crashes after page 242
links
write.csv(links, "data/links.csv")


# add the base URL to each link
full_links <- paste0("https://www.neubauprojekte.ch", links)
write.csv(full_links, "data/full_links.csv")


# Put it all together
## Create unique list of links
full_links_unique <- unique(full_links)

# Something is maybe wrong but lets continue
# create empty lists to store results
addresses <- list()
house_data_list <- list()

# loop over each link in full_links_unique
for (link in full_links_unique) {
  
  # get the address for this link
  address <- get_address(link)
  addresses <- c(addresses, address)
  
  # get the house data for this link
  house_data <- get_house_data(link, address)
  house_data_list <- c(house_data_list, list(house_data))
  
  # add a random sleep time between 1 and 10 seconds
  Sys.sleep(runif(1, 1, 10))
}

# combine the house data from all links into one data frame
all_house_data <- do.call(rbind, house_data_list)
all_house_data

# see the structure
glimpse(all_house_data)

df <- all_house_data[complete.cases(all_house_data), ]
glimpse(df)

# Separate the address column zip and name
df$street <- sub("(.*?),.*", "\\1", df$address); df$street <- NULL
df$zip <- sub(".*?(\\d{4}),.*", "\\1", df$address)
df$name <- sub(".*,\\s*(.*)", "\\1", df$address)
df$address <- NULL

df$zip_name <- paste(df$zip, df$name, sep = " ")


# Geocode
# load ggmap package
library(ggmap)
library(tmap)
library(tmaptools)

library(tidyverse)
library(readxl) #for importing the pharmacy CSVs below
library(sf)
library(mapview)

# register your API key
# y0uR_ap1_k3y_h3r3

ggmap::register_google("y0uR_ap1_k3y_h3r3", write=TRUE) 
geocoded <- ggmap::geocode(df$zip_name)
geocoded

# add the latitude and longitude values to the original dataframe
df$lat <- geocoded$lat
df$lon <- geocoded$lon

write.csv(df, "data/df_for_Shiny.csv")

#################
df <- read.csv("data/df_for_Shiny.csv")
write.csv(df, "basic_shiny/df_for_Shiny.csv")
  