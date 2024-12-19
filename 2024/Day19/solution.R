setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

# add one since index starts at 1 for R
input <- readLines(file_name)
towels <- strsplit(input[1], ", ")[[1]]
patterns <- input[-(1:2)]

cache <- collections::dict()
possible_pat <- function(towels, pat){
  
  if(cache$has(pat)){
    return(cache$get(pat))
  }
  
  if(pat == "") return(1)
  
  ans <- 0
  for(tow in towels){
    
    if(startsWith(pat, tow)){
      ans <- ans + possible_pat(towels, gsub(paste0("^", tow), "", pat))
    }
  }
  cache$set(pat, ans)
  
  ans
  
}

res <- sapply(patterns, \(x) possible_pat(towels, x))
# Part 1
sum(res > 0)
# Part 2
as.character(sum(res))
