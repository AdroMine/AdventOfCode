setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'example.txt'
file_name <- 'input.txt'

input <- strsplit(readr::read_file(file_name), "\n\n")[[1]] |> 
  lapply(\(x) strsplit(x, "\n")[[1]])


winning_machines <- function(part2 = FALSE){
  
  ans <- 0
  for(inst in input){
    
    nums <- stringr::str_extract_all(inst, "[+\\-]?\\d+") |> lapply(as.numeric) |> unlist()
    x <- matrix(c(nums[1:4]), nrow = 2, byrow = FALSE)
    y <- matrix(nums[5:6], ncol = 1)
    if(part2) y <- y + 10000000000000
    sol <- as.numeric(solve(x, y))
    # check solutions were integer
    if(all(x %*% round(sol) == y)) {
      # if part 2 answers button presses should be <= 100
      if(all(sol > 0) && (part2 || (!part2 && all(sol <= 100)))) {
      ans <- ans + sum(sol * c(3,1))
    }
    
  }
  
  }
  as.character(ans)
}

winning_machines()
winning_machines(TRUE)


