setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(stringr)

input <- readLines("input.txt")

# Data Parsing
nearby_tickets_idx <- which(grepl("^nearby", input))
nearby_tickets <- input[(nearby_tickets_idx+1):length(input)]

my_ticket_idx <- which(grepl("^your ticket", input))
my_ticket <- input[my_ticket_idx+1]

rules <- input[1:(my_ticket_idx - 2)]
rules <- str_match_all(rules, "^([a-z ]+): (\\d+)-(\\d+) or (\\d+)-(\\d+)")
rules <- as.data.frame(t(sapply(rules, function(x) matrix(x[,-1], ncol = 5))))
rules[,2:5] <- lapply(rules[,2:5], as.integer)
names(rules) <- c("class","min1", "max1", "min2", "max2")


# part 1
all_tickets <- str_split_fixed(nearby_tickets, ",", Inf)
mode(all_tickets) <- "integer"
size <- dim(all_tickets)

valid <- sapply(all_tickets, function(n) any((rules$min1 <= n & n<=rules$max1) | (rules$min2 <=n & n<=rules$max2)))
dim(valid) <- size

sum(unlist(sapply(1:nrow(all_tickets), function(i) if(!all(valid[i,])) all_tickets[i, !valid[i,]])))


# Part 2
tickets <- all_tickets[apply(valid, 1, all),] # extract valid tickets

# get possible class candidates for each position
candidates <- apply(rules, 1, function(row) 
    which(
        apply(matrix(dplyr::between(tickets,row[2], row[3]) | dplyr::between(tickets, row[4], row[5]),
                     nrow = nrow(tickets), 
                     ncol = ncol(tickets)), 
                     2, all)
          )
)
names(candidates) <- rules$class

# From the list of candidates start with the one with only candidate
# and remove this candidate from all else, repeat as many times as there are rules
# removing one candidate from all each time
# and in the end getting a list that only consists of one candidate for each rule class
ord <- names(sort(sapply(candidates, length)))
candidates <- candidates[ord]
for(i in 1:(length(candidates)-1)){
    candidates[(i+1):length(candidates)] <- lapply(candidates[(i+1):length(candidates)], 
                                                   function(x) setdiff(x, candidates[[i]]))
}
dep <- grep('departure', names(candidates)) # extract departure rules
prod(as.integer(str_split(my_ticket, ",")[[1]])[unlist(candidates[dep])])


