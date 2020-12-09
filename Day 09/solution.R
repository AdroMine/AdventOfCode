setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(Rfast)
library(purrr)
library(data.table)

input <- as.numeric(readLines("input.txt"))

for(i in 26:length(input)){
    preamble <- input[(i-25):(i-1)]
    if(sum(Rfast::nth(preamble, 2, descending = TRUE), max(preamble)) < input[i])
        break
    if( !any(colSums(comb_n(preamble, 2)) == input[i]) )
        break
}

# Answer 1
print(n <- input[i])

# Answer 2
input2 <- input[-i]
input2 <- input2[input2 < n]

all_contiguous_sums <- data.table::frollsum(input2, 2:(length(input2)-1))
sum_in <- which(map_lgl(all_contiguous_sums, ~any(. == n)))
idx <- which(all_contiguous_sums[[sum_in]] == n)

sum(range(input2[(idx-sum_in):idx]))

