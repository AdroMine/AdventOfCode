setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
seat_ids <- readLines("input.txt")

# Seat IDs are binary numbers, convert F and L -> 0 B and R -> 1
seat_ids <- gsub("F|L", "0", seat_ids)
seat_ids <- gsub("B|R", "1", seat_ids)

# convert binary to integer
ids <- strtoi(seat_ids, 2)

# Answer 1
max(ids)

# Answer 2
setdiff(min(ids):max(ids), ids)
