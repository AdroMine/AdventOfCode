setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- readLines('input.txt')
# Part 1 and 2 together
instructions <- stringr::str_extract_all(input,
                                         "mul\\(\\d+,\\d+\\)|do\\(.*?\\)|don't\\(.*?\\)") |> 
  unlist()

p1 <- 0
p2 <- 0
enabled <- TRUE
for(i in seq_along(instructions)) {
  
  if(grepl("do\\(", instructions[i])){
    enabled <- TRUE
  } else if (grepl("don't", instructions[i])) {
    enabled <- FALSE
  } else {
    nums <- stringr::str_extract_all(instructions[i], "\\d+")[[1]] |> as.integer()
    p1 <- p1 + prod(nums)
    p2 <- p2 + prod(nums) * enabled
  }
}

p1
p2






# Separately
instructions <- stringr::str_extract_all(input, "mul\\(\\d+,\\d+\\)") |> unlist()

# Part 1
stringr::str_extract_all(instructions, "\\d+") |> 
  lapply(as.integer) |> 
  sapply(prod) |> 
  sum()


# Part 2
instructions2 <- stringr::str_extract_all(input, "mul\\(\\d+,\\d+\\)|do\\(.*?\\)|don't\\(.*?\\)") |> 
  unlist()

enabled <- TRUE
for(i in seq_along(instructions2)){
  
  if(grepl("^do\\(\\)", instructions2[i])){
    enabled <- TRUE
    instructions2[i] <- ""
  } else if (grepl("don't", instructions2[i])){
    enabled <- FALSE
    instructions2[i] <- ""
  }
  
  if(!enabled){
    instructions2[i] <- ""
  } 
}

instructions2[instructions2 != ""] |> 
stringr::str_extract_all("\\d+") |> 
  lapply(as.integer) |> 
  sapply(prod) |> 
  sum()

