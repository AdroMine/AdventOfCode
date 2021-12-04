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




# Using 3D arrays instead -------------------------------------------------
# inspired from https://www.reddit.com/r/adventofcode/comments/r8i1lq/comment/hn63vwj/

b <- array(as.matrix(all_boards), dim = c(5, n_boards, 5))
b <- aperm(b, c(1, 3, 2))               # make 3rd dim as the index for board
# now b is a 3d array with one 5x5 board accessed as b[, , i]

scores <- vector("numeric", n_boards)
i <- 1

for(n in input){
    b[b == n] <- -1
    m = (b == -1)
    win <- apply((apply(m, c(3,1), all) | apply(m, c(3, 2), all)), 1, any)
    if(any(win)){
        scores[i] <- sum((b * !m)[,,win]) * n
        i <- i + 1
        b[,,win] <- -2
    }
}

print(paste("Part", 1:2, "=", scores[c(1, i-1)]))
