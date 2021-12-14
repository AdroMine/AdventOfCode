setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

#### Using Transition Matrix

# Read in input
input <- readLines("input.txt")

start <- input[1]

mapping <- input[-c(1:2)] %>%
    strsplit(" -> ") %>% 
    # create list(polymer, list(pol1, pol2))
    lapply(function(x){
        pair <- strsplit(x[1],"")[[1]]
        ins  <- x[2]
        new_pols <- c(
            paste0(pair[1], ins), 
            paste0(ins, pair[2])
        )
        c(x[1], list(new_pols))
    })

pairs <- sapply(mapping, '[[', 1)
new_polymers <- lapply(mapping, '[[', 2)

mapping <- setNames(new_polymers, nm = pairs)

transit_matrix <- matrix(0, nrow = length(mapping), length(mapping),
                         dimnames = list(pairs, pairs))

# mark transitions (each polymer transits into two polymers with 100% prob)
for(pair in pairs){
    transit_matrix[pair, mapping[pair][[1]]] <- 1
}


# Starting letters
N <- nchar(start) - 1
start <- strsplit(start, "")[[1]]

# initial state of polymers
pol_cntr <- setNames(rep(0, length(pairs)), pairs)

# for initial polymers, make count = 1
for(i in 1:N){
    pol <- paste0(start[i], start[i+1])
    pol_cntr[pol] <- pol_cntr[pol] + 1
}

# function to print count of letters from polymers
polymer_to_letter <- function(pol_cntr){
    
    count <- setNames(rep(0, 26), LETTERS)
    
    for(polymer in names(pol_cntr)){
        
        ch <- strsplit(polymer, "")[[1]]
        count[ch[1]] <- count[ch[1]] + pol_cntr[polymer]
        count[ch[2]] <- count[ch[2]] + pol_cntr[polymer]
        
    }
    count[start[1]]   <- count[start[1]] + 1
    count[start[N+1]] <- count[start[N+1]] + 1
    
    k <- sort(count %/% 2)
    k <- k[k > 0]
    tail(k, 1) - head(k,1)
}


tmp <- transit_matrix
for(step in 1:40){
    pol_cntr <- pol_cntr %*% tmp
    if(step %in% c(10, 40)){
        res <- setNames(as.vector(pol_cntr), nm = colnames(pol_cntr))
        print(polymer_to_letter(res), digits = 22)
    }
}

