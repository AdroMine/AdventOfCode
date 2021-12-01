setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(dplyr)      # for lag
library(data.table) # for rolling sum

input <- readLines("input.txt")
input <- as.numeric(input)


# Part 1

increases <- input - lag(input)

sum(increases > 0, na.rm = TRUE)


# Part 2

sliding_sums <- data.table::frollsum(input, n = 3)

increases <- sliding_sums - lag(sliding_sums)

sum(increases > 0, na.rm = TRUE)


# Part 2 optimised
sum(input > lag(input, 3), na.rm = TRUE)
