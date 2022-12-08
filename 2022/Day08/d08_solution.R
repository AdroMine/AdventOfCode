setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file <- 'sample.txt'
file <- 'input.txt'
widths <- nchar(readLines(file, n = 1))

input <- read.fwf(file, rep(1, widths))
R <- nrow(input)
C <- ncol(input)

visible <- matrix(FALSE, nrow = R, ncol = C)
visible[c(1,R), ] <- TRUE
visible[, c(1,C)] <- TRUE


# for each non edge item
for(i in 2:(R-1)){
  for(j in 2:(C-1)){
    print(sprintf("i = %d, j = %d", i,j))
    
    pt <- input[i, j]
    left_visible <- all(input[1:(i-1), j] < pt)
    right_visible <- all(input[(i+1):R, j] < pt)
    top_visible <- all(input[i, 1:(j-1)] < pt)
    bottom_visible <- all(input[i, (j+1):C] < pt)
    visible[i,j ] <- left_visible || right_visible || top_visible || bottom_visible
    
  }
}

sum(visible)

# Part 2

distance <- matrix(0, nrow = R, ncol = C) # viewing distance of each point

for(i in 2:(R-1)){
  for(j in 2:(C-1)){
    print(sprintf("i = %d, j = %d", i,j))
    
    pt <- input[i, j]
    .f <- function(x) x >= pt
    left_d   <- i - Position(.f, input[1:(i-1), j], right = TRUE, nomatch = 1)
    bottom_d <- Position(.f, input[(i+1):R, j], right = FALSE, nomatch = R - i)
    top_d    <- j - Position(.f, input[i, 1:(j-1)], right = TRUE, nomatch = 1)
    right_d  <- Position(.f, input[i, (j+1):C], right = FALSE, nomatch = C - j)
    distance[i,j ] <- left_d * right_d * top_d * bottom_d
    
  }
}

max(distance)
