setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# input <- readr::read_file('example.txt') |> 
input <- readr::read_file('input.txt') |>
  strsplit("\n\n")
fpart <- strsplit(input[[1]][1], "\\n")[[1]] |> strsplit("\\|") |> lapply(as.integer) |> do.call(rbind, args = _)
spart <- strsplit(input[[1]][2], '\\n')[[1]] |> strsplit(",") |> lapply(as.integer)


p1 <- 0
p2 <- 0

for(i in seq_along(spart)){
  
  print_order <- spart[[i]]
  valid <- TRUE
  for(j in seq_along(print_order)){
    num <- print_order[j]
    forward_part <- print_order[-c(1:j)]
    
    conditions <- fpart[fpart[,1] == num,2]
    if(!all(forward_part %in% conditions)){
      valid <- FALSE
    }
  }
  
  if(valid) p1 <- p1 + print_order[length(print_order) %/% 2 + 1]
  
  # Part 2
  if(!valid) {
    # something likke bubble sort with custom number difference rule
    copy <- print_order
    n <- length(copy)
    swapped <- FALSE
    for(k in 1:n){
      
      for(j in 1:(n-1)) {
        
        num1 <- copy[j]
        num2 <- copy[j + 1]
        if(!num2 %in% fpart[fpart[,1] == num1,2]) {
          swapped <- TRUE
          copy[j+1] <- num1
          copy[j]   <- num2
        }
      }
      if(!swapped) break
    }
    mid_part <- copy[length(copy) %/% 2+ 1]
    p2 <- p2 + copy[length(copy) %/% 2 + 1]
  }
  
}

p1
p2
