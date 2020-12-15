setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(assertthat)
library(memoise)
library(data.table)
input <- readLines("input.txt")

# convert number to binary and return as char vector
to_bit <- function(num, length = 35) {
  assert_that(is.numeric(num))
  as.character(num %/% (2^(length:0)) %% 2)
}

to_dec <- function(num){
  sum(as.integer(num) * (2 ^ (35:0)))
}

memory <- list()
for(line in input){
  if(startsWith(line, "mask")){
    mask <- strsplit(str_sub(line, 8), "")[[1]]
    idx <- which(mask!="X")
  } else {
    add_val <- str_match(line, "^mem\\[(\\d+)\\] = (\\d+)")
    addr <- add_val[2]
    
    # convert number to binary
    val <- to_bit(as.integer(add_val[3]))
    val[idx] <- mask[idx]
    val <- to_dec(val)
    memory <- modifyList(memory, setNames(list(val), addr))
  }
}
sum(unlist(memory[!is.na(memory)]))


# Part 2 

# func to create combinations of address , 
# assuming mask is string
genaddr <- function(mask){
  # base case
  if(!str_detect(mask, "X"))
    return(mask)

  if(length(mask)==1){
    mask <- strsplit(mask, "")[[1]]
  }
  n <- length(mask)
  x <- which(mask == 'X')[1]
  
  p1 <- paste(mask[1 : (x-1)], collapse = "")
  if(x == 1){ # boundary condition first digit is X
    p1 <- ""
  }
  p2 <- paste(mask[(x+1):n], collapse = "")
  if(x==n) # boundary condition, last digit is X
    p2 <- ""
  # create 2 combinations by replacing one X with 0 and 1
  combs <- paste0(p1, 0:1, p2)
  
  # recursive call
  c(genaddr(combs[1]),
    genaddr(combs[2]))
}
# memoised version
genaddr_mem <- memoise::memoise(genaddr)

memory <- vector('character', 1e6)
values <- vector('numeric', 1e6)
tmp <- data.table(memory, values)

i <- 1L
for(line in input){
  if(startsWith(line, "mask")){
    mask <- strsplit(str_sub(line, 8), "")[[1]]
    idx <- which(mask!="0")
  } else {
    add_val <- str_match(line, "^mem\\[(\\d+)\\] = (\\d+)")
    val <- as.integer(add_val[3])
    addr <- to_bit(as.integer(add_val[2]))
    
    # memory address decoding
    addr[idx] <- mask[idx]
    memory_addresses <- genaddr_mem(paste(addr, collapse = ""))
    new_vals <- length(memory_addresses)
    
    set(tmp, i : (i + new_vals - 1), j = 1L, memory_addresses)
    set(tmp, i : (i + new_vals - 1), j = 2L, val)
    i <- i + new_vals
  }
}

print(sum(tmp[, .SD[.N], by = memory]$values), digits = 22)

# Alternative
# Create memory as an environment!
# can assign new variables and values to old values with the same command
# Slower than data.table method though
memory <- new.env()

for(line in input){
  if(startsWith(line, "mask")){
    mask <- strsplit(str_sub(line, 8), "")[[1]]
    idx <- which(mask!="0")
  } else {
    # message(line)
    add_val <- str_match(line, "^mem\\[(\\d+)\\] = (\\d+)")
    val <- as.integer(add_val[3])
    addr <- to_bit(as.integer(add_val[2]))
    
    # memory address decoding
    addr[idx] <- mask[idx]
    memory_addresses <- genaddr_mem(paste(addr, collapse = ""))
    new_vals <- length(memory_addresses)
    invisible(lapply(memory_addresses, assign, value = val, envir = memory))
  }
}
print( sum(unlist(as.list(memory))), digits = 22)
