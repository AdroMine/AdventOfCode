setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)


# Read and Transform input ------------------------------------------------

# Read in input
# file_name <- "sample.txt"
file_name <- "input.txt"

input <- readLines(file_name)

template <- input[1]
mapping <- input[-c(1:2)] %>% strsplit(" -> ")

pairs <- sapply(mapping, '[', 1)
insertions <- sapply(mapping, '[', 2)

mapping <- setNames(insertions, nm = pairs)


# Solution ----------------------------------------------------------------

N <- nchar(template) - 1
start <- strsplit(template, "")[[1]]

# vector to store state of polymers (counts at each step)
pol_cntr <- setNames(rep(0, length(mapping)), names(mapping))

# for initial polymers, make count = 1
for(i in 1:N){
    pol <- paste0(start[i], start[i+1])
    pol_cntr[pol] <- pol_cntr[pol] + 1
}

solve <- function(pol_cntr, start, steps){
    
    for(step in 1:steps){
        
        # store starting state
        tmp <- pol_cntr
        
        # for all polymers that exist
        for(polymer in names(pol_cntr[pol_cntr > 0])){
            
            # will split, so reduce by 1 for each
            tmp[polymer] <- tmp[polymer] - pol_cntr[polymer]
            
            # create 2 new polymers (for each count)
            new <- unname(mapping[polymer])    # new mid letter
            ch <- strsplit(polymer, "")[[1]]   # seperate into 2 letters
            pol1 <- paste0(ch[1], new)         # first polymer
            pol2 <- paste0(new, ch[2])         # second polymer
            
            # increase the count for two new polymers
            # each existing creates new polymers
            tmp[pol1] <- tmp[pol1] + pol_cntr[polymer]
            tmp[pol2] <- tmp[pol2] + pol_cntr[polymer]
            
        }
        pol_cntr <- tmp
    }
    
    # vector to store count of each letter
    count <- setNames(rep(0, 26), LETTERS)
    
    # for each polymer count the letters
    for(polymer in names(pol_cntr)){
        
        ch <- strsplit(polymer, "")[[1]]
        count[ch[1]] <- count[ch[1]] + pol_cntr[polymer]
        count[ch[2]] <- count[ch[2]] + pol_cntr[polymer]
        
    }
    # each letter was counted twice (NBC -> NB BC, B is counted twice)
    # except for the starting and ending letter, so add 1 to each and then 
    # divide by two each count
    count[start[1]] <- count[start[1]] + 1
    count[start[N+1]] <- count[start[N+1]] + 1
    
    k <- sort(count %/% 2)
    k <- k[k > 0]
    tail(k, 1) - head(k,1)
    
}


print(solve(pol_cntr, start, 10), digits = 22)
print(solve(pol_cntr, start, 40), digits = 22)
