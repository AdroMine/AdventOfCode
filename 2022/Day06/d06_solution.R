setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')
input <- strsplit(input, '')[[1]]

first_n_uniq_chars <- function(input, n){
  
  for(i in 1:(length(input) - n)){
    
    part <- input[i:(i+n-1)]
    
    common <- FALSE
    for(j in 1:n){
      if(part[j] %in% part[-j]){
        common <- TRUE
        break
      }
    }
    
    if(!common) break
    
  }
  
  i + n - 1
}

# Part 1
first_n_uniq_chars(input, 4)
# Part 2 
first_n_uniq_chars(input, 14)



# Another solution
first_n_uniq_chars2 <- function(input, n){
  
  for(i in 1:(length(input) - n)){
    
    part <- input[i:(i+n-1)]
    
    if(length(unique(part)) == n) break
    
  }
  
  i + n - 1
}

first_n_uniq_chars2(input, 4)
first_n_uniq_chars2(input, 14)
