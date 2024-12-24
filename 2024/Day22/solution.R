setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- as.numeric(readLines(file_name))

# below does the trick to avoid 32 bit integer bit operations in R, 
# but it is very slow
one_round <- function(num){
  
  # num <- bitops::bitXor(num%%pn, (num%%pn) * 64) %% pn
  # num <- bitops::bitXor(num%%pn, num %/% 32) %% pn
  # num <- bitops::bitXor(num%%pn, (num%%pn) * 2048) %% pn
  # mixing of n with n * (power of 2) is n ^ (n << or >> power)
  # pruning is % (2^24 - 1) - keep last 24 bits of number
  
  num <- bitops::bitXor(num, bitops::bitAnd(bitops::bitShiftL(num, 6), 0xFFFFFF))
  num <- bitops::bitXor(num, bitops::bitAnd(bitops::bitShiftR(num, 5), 0xFFFFFF))
  num <- bitops::bitXor(num, bitops::bitAnd(bitops::bitShiftL(num, 11), 0xFFFFFF))
  
  num
  
}

secret_number <- function(initial, rounds){
  
  num <- initial
  for(r in seq_len(rounds)){
    num <- one_round(num)
  }
  num
}

p1 <- 0
for(i in seq_along(input)){
  print(i)
  res <- secret_number(input[i], 2000)
  p1 <- p1 + res
}

p1

