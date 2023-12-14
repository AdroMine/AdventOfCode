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
prev_score <- 0
cycles <- vector('numeric', 1e5)
# while(i < 1e9) {
while(i < 1000) {
  
  #north
  mat <- slide_rocks(mat)
  mat <- rotate(mat)
  
  #west
  mat <- slide_rocks(mat)
  mat <- rotate(mat)
  #south
  mat <- slide_rocks(mat)
  mat <- rotate(mat)
  #east
  mat <- slide_rocks(mat)
  mat <- rotate(mat)
  
  new_score <- load_north_beam(mat)
  # if(new_score == prev_score) break
  prev_score <- new_score
  cycles[i] <- new_score
  
  i <- i+1
}

new_score
