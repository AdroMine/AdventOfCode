setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- as.integer(readLines("input.txt"))

# Add start and end and sort
input <- sort(c(input, max(input) + 3, 0))

# Answer 1
differences <- input[-1] - input[-length(input)]
prod(table(differences))

# Answer 2
# initialise empty vector
combs <- vector("integer", length = length(input)-1)

for(i in 1:(length(input)-1)){
    # Extract next
    n <- input[i]
    nxt_nums <- input[(i):(i+3)]
    nxt_nums <- na.omit(nxt_nums[nxt_nums - n <=3])
    # Get possible combos
    combs[i] <- switch(length(nxt_nums), 1, 1, 2, 4)
}

# Go through list and replace pattern [4,2] with [4, 1] and [4, 4] with [7,1]
for(i in length(combs):2){
    if(combs[i] == 2 && combs[i-1] == 4)
        combs[i] <- 1
    if(combs[i] == 4 && combs[i-1] == 4){
        combs[i] <- 1
        combs[i-1] <- 7
    }
}

as.character(prod(combs, na.rm = TRUE))

