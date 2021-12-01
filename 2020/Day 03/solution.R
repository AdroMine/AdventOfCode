dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(dir)

# Read file
input <- readLines("input.txt")

# Find no of trees in path
no_of_trees <- function(input, right, down){
    cols <- nchar(input[1])
    rows <- length(input)
    
    # Create sequence
    row_ids <- (seq(from = 0, to = rows-1, by = down) + 1)
    col_ids <- (seq(from = 0, to = rows*right, by = right) %% cols   + 1)[1:length(row_ids)]
    
    # Vectorised subset
    chars <- substr(input[row_ids], col_ids, col_ids)
    sum(chars == '#')
}

# Answer to part 1
no_of_trees(input, 3, 1)

# Answer to part 2
prod(purrr::map2_dbl(c(1, 3, 5, 7, 1), c(1, 1, 1, 1, 2), 
                function(right, down) no_of_trees(input, right, down)))
