setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- strsplit(readr::read_file(file_name), "\n\n")[[1]]

locks <- list()
keys <- list()

for(part in input){
  mat <- strsplit(part, "\n")[[1]] |> strsplit("") |> do.call(rbind, args = _)
  heights <- apply(mat, 2, \(x) sum(x == "#") - 1)
  if(all(mat[1,] == "#")){
    # lock
    locks <- c(locks, list(heights))
  } else {
    # key
    keys <- c(keys, list(heights))
  } 
}

p1 <- 0
for(lock in locks){
  for(key in keys){
    if(!any((key + lock) > 5)){
      p1 <- p1 + 1
    }
  }
}

p1
