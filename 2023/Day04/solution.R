
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

file_name <- 'input.txt'
input <- readLines(file_name) |> 
  strsplit(' \\| ')

p1 <- 0
# part2, initialise with 1
scratch_cards <- rep(1, length(input))

for(i in seq_along(input)) {
  
  line <- input[[i]]
  
  winning_nums <- gsub("^.*: ", "", line[1]) |> stringr::str_extract_all('\\d+')
  winning_nums <- as.numeric(winning_nums[[1]])
  
  our_nums <- stringr::str_extract_all(line[2], '\\d+')[[1]] |> as.numeric()
  
  wins <- sum(our_nums %in% winning_nums) 
  
  
  if(wins > 0){
  # Part 1
    p1 <- p1 + 2^(wins-1)
    
    # Part 2
    inc_cards <- (i+1) : (i+wins)
    # invalid values will just create NAs
    scratch_cards[inc_cards] <- scratch_cards[inc_cards] + (scratch_cards[i])
  }
}

p1
sum(scratch_cards, na.rm = TRUE)


# Alternative Part 1
readLines('input.txt') |> 
  strsplit("(:|\\|) ") |> 
  lapply(stringr::str_extract_all, "\\d+") |> 
  lapply(\(x) length(intersect(x[[2]], x[[3]]))) |> 
  sapply(\(x) bitwShiftL(1, x-1)) |> 
  sum(na.rm = TRUE)
