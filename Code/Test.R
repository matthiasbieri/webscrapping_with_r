# Step 1: Read the file
deck <- read.csv("https://gist.githubusercontent.com/garrettgman/9629323/raw/ee5dfc039fd581cb467cc69c226ea2524913c3d8/deck.csv")

# 2. Write a function "deal" that returns the top card of the deck. This function will always
# return the same card because the cards are not shuffled.
deal <- function(data) {
  return(data[1, ])
}

deal(deck)

#3. Write a function "shuffle" which shuffles the cards. Hint: Use the function "sample" to
#generate a random index. Use this index to access the individual lines of the data frame "deck".
shuffle <- function(data) {
  data <- data[sample(nrow(data)), ]
  return(data)
}

# 4. Now use the two created functions to shuffle the cards first and then draw the first card from the shuffled deck.
deck <- shuffle(deck)
top_card <- deal(deck)
print(top_card)



# Define the vector
vec <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)

# Count the number of odd numbers
odd_count <- sum(vec %% 2 == 1)

# Count the number of even numbers
even_count <- sum(vec %% 2 == 0)

# Print the results
cat("Number of odd numbers:", odd_count, "\n")
cat("Number of even numbers:", even_count, "\n")

