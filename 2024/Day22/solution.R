setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- as.numeric(readLines(file_name))

pn <- 16777216
one_round <- function(num){
  
  num <- bitops::bitXor(num%%pn, (num%%pn) * 64) %% pn
  num <- bitops::bitXor(num%%pn, num %/% 32) %% pn
  num <- bitops::bitXor(num%%pn, (num%%pn) * 2048) %% pn
  
  num
  
}

secret_number <- function(initial, rounds){
  
  num <- initial
  for(r in rounds){
    num <- one_round(num)
  }
  num
}

for(number in input){
  
}
