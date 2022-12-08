setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# file <- 'sample.txt'
file <- 'input.txt'
widths <- nchar(readLines(file, n = 1))

# use matrix, not data.frame, matrix indexing and comparisons will be much faster
input <- read.fwf(file, rep(1, widths)) |> as.matrix()
R <- nrow(input)
C <- ncol(input)


visible <- 2*R + 2*(C-2) # initially edges are visible
best_distance <- 0

.f <- function(x) !x

# for each non edge item
for(i in 2L:(R-1L)){
  for(j in 2L:(C-1L)){
    
    pt <- input[i, j]
    
    # create boolean vector for horizontal & vertical directions
    horizontal <- input[i, ] < pt
    vertical   <- input[, j] < pt
    
    left  <- horizontal[1L:(j - 1L)] # equivalent to head(horizintal, j-1)
    up    <- vertical  [1L:(i - 1L)] # same as head(vertical, i - 1)
    
    right <- horizontal[(j + 1L):C] # same as tail(horizontal, -j)
    down  <- vertical  [(i + 1L):R] # same as tail(vertical, -i)
    
    # Part 1
    visible <- visible + (all(left) || all(right) || all(up) || all(down))
    
    # Part 2
    # use Position to find first FALSE element in vector, 
    # for searching left and up, we look for the first element from the end
    # for right/down, we look at first element from start
    # adjust for current position and end of array
    d_left  <- j - Position(.f, left,  right = TRUE,  nomatch = 1)
    d_right <-     Position(.f, right, right = FALSE, nomatch = C - j)
    d_up    <- i - Position(.f, up,    right = TRUE,  nomatch = 1)
    d_down  <-     Position(.f, down,  right = FALSE, nomatch = R - i)
    
    score <- d_left * d_right * d_up * d_down
    best_distance <- max(score, best_distance)
    
    
  }
}

visible
best_distance

