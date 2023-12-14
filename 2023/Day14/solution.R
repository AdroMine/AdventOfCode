setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
W <- nchar(readLines(file_name, n = 1))
input <- as.matrix(read.fwf(file_name, widths = rep(1, W), comment.char = ''))

mat <- input  

slide_rocks <- function(mat){
  for(i in 2:nrow(mat)) {
    for(j in 1:ncol(mat)) {
      if(mat[i,j] == 'O') {
        k <- i
        while(k > 1 && mat[k-1,j] == '.') k <- k - 1
        if(k < i){
          mat[k,j] <- 'O'
          mat[i,j] <- '.'
        }
      }
    }
  }
  mat
}


rotate <- function(x) t(apply(x, 2, rev))

load_north_beam <- function(mat){
  score <- 0
  R <- nrow(mat)
  sum(rowSums(mat == 'O') * R:1)
}

# Part 1
slide_rocks(input) |> load_north_beam()

i <- 1

# vector to hold the loop iterations when we saw this score
cycles <- vector('list', 1e6)

while(i <= 1e9) {
  
  print(as.character(i))
  for(round in 1:4){
    #rotate and slide
    mat <- slide_rocks(mat)
    mat <- rotate(mat)
  }
  
  new_score <- load_north_beam(mat)
  cycles[[new_score]] <- c(cycles[[new_score]], i)
  
  if(length(cycles[[new_score]]) > 2) {
    # compute time difference when we last saw this score
    cyc_lens <- diff(cycles[[new_score]])
    # if saw at same intervals again and again, then skip ahead
    if(length(unique(cyc_lens)) == 1){
      revolutions <- (1e9-i-1) %/% cyc_lens[1]
      i <- i + (revolutions * cyc_lens[1])
    }
  }
  i <- i+1
}

new_score
