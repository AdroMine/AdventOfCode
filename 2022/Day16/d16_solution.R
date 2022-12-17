setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# Parse Inputs ------------------------------------------------------------

# input <- readLines('sample.txt')
input <- readLines('input.txt')

lines <- stringr::str_match_all(
    input,
    "Valve ([A-Z]+) has flow rate=(\\d+); tunnels? leads? to valves? (.*)$"
) %>% 
    do.call(rbind, .)


valves        <- lines[,2]
flow_rates    <- setNames(as.integer(lines[,3]), valves)
tunnels       <- setNames(strsplit(lines[,4], ", "), valves)
valves_on_off <- setNames(vector('logical', nrow(lines)), valves)


# Compute Distances -------------------------------------------------------

# some valves don't lead anywhere

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
    distances[distances == Inf] <- NA
    diag(distances) <- NA
    distances
}
distances <- get_distances(valves, tunnels)

# valves that are actually on
on_valves <- unique(c('AA', valves[flow_rates[valves] > 0]))

# Find max pressure released possible -------------------------------------

dp <- collections::dict()

high_pres <- sum(flow_rates)
max_pressure <- function(time_left, on_off, p1){
    if(time_left <= 0) return(0)
    
    key <- list(time_left, on_off, p1)
    if(dp$has(key)) 
        return(dp$get(key))
    
    mp <- 0
    press <- sum(flow_rates[on_off])
    
    # if all valves on, no need to do further processing
    if(press >= high_pres) 
        return(time_left * press)
    # either switch on a valve (only valves with +ive rates)
    if(!on_off[p1] && flow_rates[p1] > 0){
        new_on_off <- on_off
        new_on_off[p1] <- TRUE
        mp <- max(mp, press + Recall(time_left-1, new_on_off, p1))
    } 
    # or move to a non-zero rate valve
    for(v in on_valves){
        if(v == p1) next
        d <- distances[p1, v] # time it will take to move from p1 to v
        if(d <= time_left)
            mp <- max(mp, press*(d) + Recall(time_left-d, on_off, v))
    }
    dp$set(key, mp)
    if(dp$size() %% 10000 == 0) print(dp$size())
    
    mp
}

max_pressure(30, valves_on_off, 'AA')

print("don't reach here")


# Part 2 another ----------------------------------------------------------

dp <- collections::dict()
max_pressure2 <- function(time_left, on_off, p1, other_players = 0){
    
    if(time_left <= 0) {
        if(other_players > 0){
            max_pressure2(26,on_off, 'AA', other_players-1)
        } else {
            return(0)
        }
    }
    
    key <- list(time_left, on_off, p1)
    if(dp$has(key)) 
        return(dp$get(key))
    
    mp <- 0
    press <- sum(flow_rates[on_off])
    if(press >= high_pres){
        return(press * time_left)
    }
    # either switch on a valve (only valves with +ive rates)
    if(!on_off[p1] && flow_rates[p1] > 0){
        new_on_off <- on_off
        new_on_off[p1] <- TRUE
        mp <- max(mp, press + Recall(time_left-1, new_on_off, p1, other_players))
    } 
    # or move to a non-zero rate valve
    for(v in on_valves){
        if(v == p1) next
        d <- distances[p1, v] # time it will take to move from p1 to v
        if(d <= time_left)
            mp <- max(mp, press*(d) + Recall(time_left-d, on_off, v, other_players))
    }
    dp$set(key, mp)
    if(dp$size() %% 10000 == 0) print(dp$size())
    
    mp
}

max_pressure2(26, valves_on_off, 'AA', 1)











# Part 2 ------------------------------------------------------------------

dp2 <- collections::dict()
max_pressure2 <- function(time_left, on_off, e_pos, h_pos){
    if(time_left == 0) return(0)
    
    key <- list(time_left, on_off, e_pos, h_pos)
    if(dp2$has(key)) 
        return(dp2$get(key))
    
    mp <- 0
    press <- sum(flow_rates[on_off])
    
    # elephant moves, human switches on
    if(time_left > 0 && !on_off[h_pos] && flow_rates[h_pos] > 0){
        new_on_off <- on_off
        new_on_off[h_pos] <- TRUE
        for(ev in tunnels[[e_pos]]){
            if(all(new_on_off)) next
            mp <- max(mp, press + Recall(time_left-1, new_on_off, ev, h_pos))
        }
    }
    # elephant switches on, human moves
    if(time_left > 0 && !on_off[e_pos] && flow_rates[e_pos] > 0){
        new_on_off <- on_off
        new_on_off[e_pos] <- TRUE
        for(hv in tunnels[[h_pos]]){
            if(all(new_on_off)) next
            mp <- max(mp, press + Recall(time_left-1, new_on_off, e_pos, hv))
        }
    }
    # both move
    if(time_left > 0){
        for(hv in tunnels[[h_pos]]){
            for(ev in tunnels[[e_pos]]){
                if(all(on_off)) next
                mp <- max(mp, press + Recall(time_left-1, on_off, ev, hv))
            }
        }
    }
    # both switch on
    if(time_left > 0 && !on_off[h_pos] && !on_off[e_pos] && flow_rates[h_pos] > 0 && flow_rates[e_pos] > 0){
        new_on_off <- on_off
        new_on_off[e_pos] <- TRUE
        new_on_off[h_pos] <- TRUE
        mp <- max(mp, press + Recall(time_left-1, new_on_off, e_pos, h_pos))
    }
    
    dp2$set(key, mp)
    
    if(dp2$size() %% 10000 == 0) print(dp2$size())
    
    mp
}

max_pressure2(26, valves_on_off, 'AA', 'AA')



