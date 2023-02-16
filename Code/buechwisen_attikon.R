# https://buechwisen-attikon.ch/angebot/

library(rvest)
library(dplyr)
library(xml2)
# Read the URL of the website into R
url <- "https://buechwisen-attikon.ch/angebot/"
webpage <- read_html(url)

# Read the addresses
webpage %>% html_nodes(".xl\\:mb-5") %>%  html_text()


webpage <- read_html(url)
text_content <- html_text(html_nodes(webpage, xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "xl\:mb-5", " " ))]'))


url <- "https://www.neubauprojekte.ch/listing/kaufen-mieten/schwyz/schuebelbach/parco-verde-schuebelbach/"
html_text(html_nodes(w))




# Read the URL of the website into R
url <- "https://www.neubauprojekte.ch/listing/kaufen-mieten/schwyz/schuebelbach/parco-verde-schuebelbach/"
webpage <- read_html(url)

## Adress extractor
adress <- webpage %>% html_nodes(".xl\\:mb-5") %>%  html_text() 
# Select the second element of the list
adress <- adress[2]
# Remove the newline and space characters from the beginning and end of the string
adress <- trimws(adress)


# Test if this goes with other urls
url <- "https://www.neubauprojekte.ch/listing/kaufen-mieten/basel-landschaft/oberwil-bl/neubau-mehrfamilienhaeuser-mit-autoeinstellhalle-9/"




extract_address <- function(url) {
  webpage <- read_html(url)
  adress <- webpage %>% html_nodes(".xl\\:mb-5") %>%  html_text() 
  adress <- adress[2]
  adress <- trimws(adress)
  return(adress)
}

adress <- extract_address(url)
adress
