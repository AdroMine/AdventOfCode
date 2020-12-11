setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(purrr)

input <- readLines("input.txt")
# example <- readLines("example.txt")

# convert to matrix of 1(fill) , 0(empty) and NA(floor)
parse_input <- function(input){
    seats <- unlist(strsplit(input, ""))
    seats[seats == "L"] <- 0
    seats[seats == "#"] <- 1
    seats[seats == "."] <- NA
    
    seats <- matrix(as.numeric(seats), 
                    nrow = length(input), 
                    ncol = nchar(input[1]), 
                    byrow = TRUE)
    
    left_pad <- rep(NA, dim(seats)[1])
    top_pad <- rep(NA, dim(seats)[2]+2)
    seats <- cbind(left_pad, seats, left_pad)
    seats <- rbind(top_pad, seats, top_pad)
    
    dimnames(seats) <- NULL
    seats
}

seats <- parse_input(input)

# globals
R <- nrow(seats)
C <- ncol(seats)
left_diags <- row(seats) - col(seats)
right_diags <- row(seats) + col(seats)

# Function to order seats
order_seats <- function(seats, p1 = TRUE){
    new_seats <- seats
    thresh <- ifelse(p1, 4, 5)
    if(!p1){
        ld <- split(seats, left_diags)
        rd <- split(seats, right_diags)
    }
    
    for(i in 2:(R-1)){
        for(j in 2:(C-1)){
            
            # get current seat
            seat <- seats[i, j]
            if(is.na(seat)) # skip if floor
                next
            if(p1){ # part 1 immediate adjacent
                rr <- max(1,i-1L) : min(R,i+1)
                cc <- max(1,j-1) : min(C,j+1)
                adj_sts <- sum(seats[rr, cc], na.rm = TRUE) - seat
            } else { # part 2 look past floor to the next seat
                
                # get all diagonal seats to current
                diag1 <- ld[[as.character(left_diags[i,j])]]
                diag2 <- rd[[as.character(right_diags[i,j])]]
                
                d1 <- min(i,j)
                d2 <- min(R-i+1, j)
                
                empty <- c(tail( na.omit( seats[i,1:(j-1) ] ), 1) == 1,      # left  adjacent
                           head( na.omit( seats[i,-(1:j)  ] ), 1) == 1,      # right adjacent
                           tail( na.omit( seats[1:(i-1),j ] ), 1) == 1,      # up    adjacent
                           head( na.omit( seats[-(1:i),j  ] ), 1) == 1,      # down  adjacent
                           tail( na.omit( diag1[1:(d1-1)  ] ), 1) == 1,      # nw    adjacent
                           head( na.omit( diag1[ -(1:d1)  ] ), 1) == 1,      # se    adjacent
                           tail( na.omit( diag2[  1:(d2-1)] ), 1) == 1,      # sw    adjacent
                           head( na.omit( diag2[-(1:d2)   ] ), 1) == 1)      # ne    adjacent
                
                # empty <- sapply(empty, function(x) ifelse(length(x)==0, FALSE, x))    # if no seats in either direcrtion
                # empty <- map_dbl(empty, as.integer)    # if no seats in either direcrtion
                
                adj_sts <- sum(empty, na.rm = TRUE)
            }
            if(seat == 0 && adj_sts == 0){
                new_seats[i, j] <- 1
            } else if(seat == 1 && adj_sts >=thresh) { 
                new_seats[i, j] <- 0
            }
        }
    }
    new_seats
}


solve <- function(p1 = True){
    prev_seats <- new_seats <- seats
    new_seats[new_seats==0] <- 1 # first assignment all get filled
    i <- 1
    while(any(new_seats!=prev_seats, na.rm = TRUE)){
        prev_seats <- new_seats
        new_seats <- order_seats(prev_seats, p1)
        i <- i+1
        message(i)
    }
    sum(new_seats, na.rm = TRUE)
}

solve(p1 = TRUE)
solve(p1 = FALSE)

