setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(purrr)

input <- readLines("input.txt")

# Find where groups start and end
n_line <- which(input == '')
record_start_idx <- c(1, n_line + 1)
record_end_idx <- c(n_line - 1, length(input))

# Create groups
groups <- map2(record_start_idx, record_end_idx, ~input[.x : .y])

# Answer 1
sum(map_dbl(groups, function(x) length(reduce(strsplit(x, ""), union))))

# Answer 2
sum(map_dbl(groups, function(x) length(reduce(strsplit(x, ""), intersect))))




