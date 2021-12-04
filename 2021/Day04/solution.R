setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- as.integer(strsplit(readLines("input.txt", n = 1), ",")[[1]])
all_boards <- read.table("input.txt", skip = 2)
n_boards <- nrow(all_boards) / 5


# extract all boards as a list of df
boards <- lapply(1:n_boards, function(i) {
    start <- (i-1) * 5 + 1
    end <- i * 5
    all_boards[start:end,]
})


# store winning order and the number which won
winners <- vector("numeric", length = n_boards)
winning_num <- vector('numeric', length = n_boards)

i <- 1

# function to see if a board has won
board_won <- function(board, marked = -1){
    any(rowSums(board) == marked*5) || any(colSums(board) == marked*5)
}

# loop through the inputs and mark
for(num in input){
    
    # for all boards still in play (not won)
    for(k in setdiff(1:n_boards, winners)){
        
        bd <- boards[[k]]
        bd[bd == num] <- -1 # mark a number as -1
        boards[[k]] <- bd
        
        # if won, store the board_number that won and the number for which it won
        if(board_won(bd)){
            winners[i] <- k
            winning_num[i] <- num
            i <- i + 1
        }
    }
    
    # if everyone has won, stop calling out the numbers
    if(all(winners > 0))
        break
}

# function to calculate the board sum
board_sum <- function(board, win_num){
    
    sum(board[board !=  -1]) * win_num
}

# Part 1
board_sum(boards[[winners[1]]], winning_num[1])

# Part 2

board_sum(boards[[winners[n_boards]]], winning_num[n_boards])
