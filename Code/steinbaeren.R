# Load the rvest package
library(rvest)

# Read the URL of the website into R
url <- "https://www.steinbaeren.ch/angebot"
webpage <- read_html(url)
webpage

# Use html_nodes to extract the elements with class "list scroll"
houses <- html_nodes(webpage, ".list.scroll")
houses


# What are my Adresses?
html_nodes(webpage, ".row.address")

# What are the col.spalteX left
html_nodes(webpage, ".col.spalte1.left") # Status
html_nodes(webpage, ".col.spalte2.left") # Etage
html_nodes(webpage, ".col.spalte3.left") # Whg-Nr.
html_nodes(webpage, ".col.spalte4.left") # Zimmer
html_nodes(webpage, ".col.spalte5.left") # Wohnfläche
html_nodes(webpage, ".col.spalte6.left") # Aussen:
html_nodes(webpage, ".col.spalte7.left") # Kaufpreis

# Extract Info (e.g. Status)
status <- html_nodes(webpage, ".col.spalte1.left") 
status # 44 Elements

h
status_text <- html_text(status)
status_text

status_attrs <- html_attrs(status)
status_attrs

# Wert von Appartement 3
xml_attrs(xml_child(status[[3]], 2))[["title"]]

status[[3]]




# How long is for example status?
n_appartments <- length(html_nodes(webpage, ".col.spalte1.left"))
n_appartments

# How long is for example status?
n_appartments <- length(html_nodes(webpage, ".col.spalte1.left"))

xml_attrs(xml_child(status[[3]], 2))[["title"]]
# Loop through it to get all the statuses
for (i in 1:n_appartments){
  status <- xml_attrs(xml_child(html_node(houses[[i]], ".col.spalte1.left"), 2))$title
}
