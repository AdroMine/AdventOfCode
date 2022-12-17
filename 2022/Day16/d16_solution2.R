setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# Parse Inputs ------------------------------------------------------------

# input <- readLines('sample.txt')
input <- readLines('input.txt')

lines <- stringr::str_match_all(
    input,
    "Valve ([A-Z]+) has flow rate=(\\d+); tunnels? leads? to valves? (.*)$"
) %>% do.call(rbind, .)

valves        <- lines[,2]
flow_rates    <- setNames(as.integer(lines[,3]), valves)
tunnels       <- setNames(strsplit(lines[,4], ", "), valves)

get_distances <- function(valves, tunnels){
    N <- length(valves)
    distances <- matrix(Inf, N, N, dimnames = list(valves, valves))
    # add existing edges, which is 1 minute for one valve to another
    for(v in valves){
        for(tn in tunnels[[v]]){
            distances[v, tn] <- 1
        }
    }
    # floyd-warshall
    for(k in 1:N){
        for(i in 1:N){
            for(j in 1:N){
                if(distances[i, j] > distances[i,k] + distances[k, j]){
                    distances[i,j] <- distances[i,k] + distances[k, j]
                }
            }
        }
    }
    distances
}
distances <- get_distances(valves, tunnels)

flow_rates <- flow_rates[flow_rates > 0]

ids <- setNames(sapply(seq_along(flow_rates), function(i){
    bitops::bitShiftL(1, i)
}), names(flow_rates))


max_rate <- function(pos, time, on_off, press){
    # store max pressure reached as a result of reaching this state of valves on/off
    dp[on_off] <<- max(dp[on_off],press)
    # for each possible non-zero valve
    for(nxt in names(flow_rates)){
        # calculate time to reach this and open valve
        new_time <- time - distances[pos, nxt] - 1
        
        # already visited or time over
        if(bitwAnd(ids[nxt], on_off) | new_time <= 0) next
        
        # recurse
        Recall(pos = nxt, 
               time = new_time, 
               on_off = bitwOr(on_off, ids[nxt]), 
               press = press + new_time*flow_rates[nxt])
    }
    return(dp)
}

# global vector of best rates
dp <- vector('integer', 1e6)

vis1 <- max_rate2(pos = 'AA', time = 30, on_off = 0, press = 0)
print(max(vis1, na.rm = TRUE))

dp <- vector('integer', 1e6)
vis2 <- max_rate2('AA', 26, 0, 0)

non_zero <- which(vis2 > 0)

# this takes around 12 seconds, bitwAnd is the blocker
best <- 0
for(k1 in non_zero){
    for(k2 in non_zero){
        if(!bitwAnd(k1, k2)){
            best <- max(best, vis2[k1] + vis2[k2])
        }
    }
}

best
