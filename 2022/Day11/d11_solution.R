setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringr)

# input <- readr::read_file('sample.txt') |>
#   gsub("\r", "", x = _) |> 
#   strsplit('\n\n') |> 
#   purrr::pluck(1)
input <- strsplit(readr::read_file('input.txt'), '\n\n')[[1]]

monkeys <- lapply(strsplit(input, '\n\\s+'), function(x){
  id <- as.integer(str_extract(x[1], '\\d+'))
  items <- str_extract_all(x[2], '\\d+')[[1]] |> as.integer()
  
  
  operation <- stringr::str_match(x[3], "^.* = (old) (.) (.*)$")[,-1]
  # creating function and using it doesn't seem to be faster than plain eval
  # op_fn <- switch(
  #   operation[2], 
  #   '*' = switch(
  #     operation[3], 
  #     'old' = function(x) x * x, 
  #     function(x) x * as.integer(operation[3])
  #   ), 
  #   '+' = switch(
  #     operation[3], 
  #     'old' = function(x) x + x, 
  #     function(x) x + as.integer(operation[3])
  #   )
  # )
  
  operation <- parse(text = gsub("^.*= ", "", x[3])) # just get old \operator num/word
  
  test <- stringr::str_extract(x[4], '\\d+') |> as.integer()
  
  test_true  <- stringr::str_extract(x[5], '\\d+') |> as.integer()
  test_false <- stringr::str_extract(x[6], '\\d+') |> as.integer()
  
  list(
    id        = id, 
    items     = items, 
    operation = operation, 
    op_fn     = op_fn, 
    test      = test, 
    t_true    = test_true + 1, 
    t_false   = test_false + 1
  )
})

play_keep_away <- function(rounds, monkeys, part2 = FALSE){
  
  # get product of all test numbers and modulo each current worry before
  # performing operation
  super_mod <- prod( vapply(monkeys, \(x) x$test, FUN.VALUE = 1L) )
  inspections <- rep(0, length(monkeys))
  
  for(r in seq_len(rounds)){
    for(m in seq_along(monkeys)){
      
      monkey <- monkeys[[m]]
      for(i in seq_along(monkey$items)){
        
        cur_worry <- monkey$items[i] %% super_mod
        new_worry <- eval(monkey$operation, list(old = cur_worry))
        if(!part2) new_worry <- new_worry %/% 3
        
        # divisibility test
        if(!(new_worry %% monkey$test)){
          # throw to test true
          monkeys[[monkey$t_true]]$items <- c(monkeys[[monkey$t_true]]$items, 
                                              new_worry)
        } else {
          # throw to test false 
          monkeys[[monkey$t_false]]$items <- c(monkeys[[monkey$t_false]]$items, 
                                               new_worry)
        }
      }
      # remove from orig list, not current monkey item
      monkeys[[m]]$items <- c()
      inspections[m] <- inspections[m] + length(monkey$items)
    }
  }
  prod(head(sort(inspections, decreasing = TRUE), 2))
}

# Part 1
play_keep_away(20, monkeys)
play_keep_away(10000, monkeys, part2 = TRUE)


