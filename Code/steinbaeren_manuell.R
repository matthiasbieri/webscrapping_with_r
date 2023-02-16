library(dplyr)
library(rvest)
library(httr2)

# Read the URL of the website into R
url <- "https://www.steinbaeren.ch/angebot"
webpage <- read_html(url)

# Read the addresses
webpage %>% html_nodes(".address") %>%  html_text()

# Use html_nodes to extract the elements with class "list scroll"
houses <- html_nodes(webpage, ".list.scroll")

# Extract the addresses
html_nodes(houses, ".row.address")

# Extract the col.spalteX left elements
status <- html_nodes(houses, ".col.spalte1.left") # Status
etage <- html_nodes(houses, ".col.spalte2.left") # Etage
whg <- html_nodes(houses, ".col.spalte3.left") # Whg-Nr.
zimmer <- html_nodes(houses, ".col.spalte4.left") # Zimmer
wohnfl <- html_nodes(houses, ".col.spalte5.left") # Wohnfläche
aussen <- html_nodes(houses, ".col.spalte6.left") # Aussen:
kaufpreis <- html_nodes(houses, ".col.spalte7.left") # Kaufpreis

## Etage
# Extract the text values of the etage elements
etage_text <- html_text(etage)

# Use regular expressions to extract only the desired text
etage_levels <- gsub(".*Ebene\\s([0-9]+(\\s&\\s[0-9]+)?).*", "\\1", etage_text)
etage_levels <- gsub("[\r\n\t]+", "", etage_levels)

# Print the extracted levels
etage_levels

# Create a data frame with the etage levels
df <- data.frame(Etage = etage_levels)

# Remove any leading or trailing white space from the Etage column
df$Etage <- trimws(df$Etage)

# Remove "Etage:Ebenen" from the Etage column
df$Etage <- gsub("Etage:Ebenen", "", df$Etage)

# Print the data frame
df


## Wohnung
whg <- html_nodes(houses, ".col.spalte3.left") # Whg-Nr.
whg_text <- html_text(whg)

# Use regular expressions to extract only the desired text
whg_name <- gsub(".*Whg-Nr.:\\s+(\\S+).*", "\\1", whg_text)
whg_name <- gsub("[\r\n\t]+", "", whg_name)

df$whg_name <- whg_name

## Rooms
rooms <- html_nodes(houses, ".col.spalte4.left") # Zimmer
room_text <- html_text(rooms)
# Use regular expressions to extract only the desired text
room_text <- gsub(".*Zimmer:\\s+(\\S+).*", "\\1", room_text)
room_text <- gsub("[\r\n\t]+", "", room_text)
df$room <- room_text

## Spaces
wohnfl <- html_nodes(houses, ".col.spalte5.left") # Wohnfläche
space_text <- html_text(wohnfl)
# Use regular expressions to extract only the desired text
space_text <- gsub(".*Wohnfläche:\\s+(\\S+).*", "\\1", space_text)
space_text
df$space <- space_text

## Outdoor
outdoor <- html_nodes(houses, ".col.spalte6.left") # Aussen:
outdoor_text <- html_text(outdoor)
df$outdoor <- tidyr::extract_numeric(outdoor_text) # Coud not construct a regular expression for this... So i used a tidyr function

## Kaufpreise
prices <- houses %>% 
  html_nodes(".col.spalte7.left") %>% 
  html_text(trim = TRUE) %>% 
  trimws()

# remove the 'Kaufpreis:' prefix and leading/trailing whitespace
value <- gsub("Kaufpreis:", "", prices)
value <- trimws(value)

# define a regular expression pattern to match the desired information
pattern <- "\\d+[\\’\\d]*\\.\\d+"

# apply the pattern to each element in the list using gsub
extracted_numbers <- lapply(value, function(x) gsub(pattern, "\\0", x))

# convert the extracted numbers to numeric values
extracted_numbers <- as.numeric(gsub("[^0-9.]", "", unlist(extracted_numbers)))

# Add to dataframe
df$prices <- extracted_numbers


## Status
status <- html_nodes(houses, ".col.spalte1.left")
houses %>% 
  html_nodes(".col.spalte1.left") %>% 
  html_text(trim = TRUE)

possible_values <- c("Frei", "Reserviert", "Verkauft")

status <- houses %>% 
  xml_find_all(".//div[@title]") %>% .[xml_attr(., "title") %in% possible_values]

# use xml_attr to extract the title attribute from each div element
status_values <- xml_attr(status, "title")

df$status <- status_values

df

# Clean the data
#replace all instances of '—' with 'NA'
df[df == "—"] <- NA
df

glimpse(df)

## Change variable type
df$room <- as.numeric(df$room)
df$space <- as.numeric(df$space)
df$status <- as.factor(df$status)

boxplot(df$prices ~ df$status)


## Add timestamp to dataframe
df$timestamp <- Sys.time()
df

## Add Adress
df$adress <- rep(c("Steinbärenhöhe 2, 6234 Triengen"))

# Save as CSV
write.csv(df, "data/steinbaeren.csv")
