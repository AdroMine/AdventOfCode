setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- strsplit(readr::read_file(file_name), '\n\n')[[1]] |> strsplit('\n') 
  
mats <- lapply(input, \(m){
  do.call(rbind, strsplit(m, ''))
})

hor_refl <- function(mat, ok_diff = 0){
  
  for(i in 2:nrow(mat)) {
    # boundary line between i-1 and i
    total_diffs <- 0
    for(j in 1:(i-1)) {
      
      if( (j+i-1) > nrow(mat) || (i-j) < 1) break
      diffs <- sum(mat[i - j,] != mat[j + i - 1,])
      total_diffs <- total_diffs + diffs
    }
    if(total_diffs == ok_diff) return(i - 1)
  }
  return(0)
}

ver_refl <- function(mat, ok_diff = 0){
  
  for(i in 2:ncol(mat)) {
    # boundary line betwen col i-1 and i
    total_diffs <- 0
    for(j in 1:(i-1)) {
      
      if((j+i-1) > ncol(mat) || (i-j) < 1) break
      diffs <- sum(mat[,i-j] != mat[,j+i-1])
      total_diffs <- total_diffs + diffs
    }
    if(total_diffs == ok_diff) return(i-1)
  }
  return(0)
}


# Part 2
p1 <- 0
p2 <- 0

for(m in mats){
  v <- ver_refl(m, 0)
  # h <- ver_refl(t(m), 0)
  h <- hor_refl(m, 0)
  p1 <- p1 + v + 100*h
  v <- ver_refl(m, 1)
  # h <- ver_refl(t(m), 1) # could also use transpose
  h <- hor_refl(m, 1)
  p2 <- p2 + v + 100*h
}

p1
p2
