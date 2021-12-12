# Other trials


# this is slow initial version, look below for faster method
# takes around 13 sec for part 2 due to grepping for small case
generate_graph <- function(st = 'start', prev = NULL, part1 = TRUE){
    e2 <- to[which(from == st)]
    
    small <- grep("[[:lower:]]", c(prev, st), value = TRUE, perl = TRUE)
    
    if(length(small) > 0){
        
        if(part1){
            e2 <- setdiff(e2, small)
        } else {
            
            if(anyDuplicated(small)){
                e2 <- setdiff(e2, small)
            }
        }
    }
    
    for(p in e2){
        
        if(p == 'end'){
            count <<- count + 1
            next
        } else {
            Recall(p, c(prev, st), part1 = part1)
        }
    }
}

count <- 0
generate_graph(st = 'start', prev = NULL, part1 = TRUE)
count

count <- 0
generate_graph(st = 'start', prev = NULL, part1 = FALSE)
count

gen_graph <- memoise::memoise(generate_graph)
count <- 0
gen_graph(st = 'start', prev = NULL, part1 = FALSE)
count



# faster, takes around 5-6 seconds
gg2 <- function(st = 'start', cant = NULL, part2 = FALSE){
    if(st == "end")
        return(1)
    
    paths <- 0
    
    e2 <- to[which(from == st)]
    if(!part2)  e2 <- setdiff(e2, cant)
    
    for(p in e2){
        
        if(toupper(p) == p){
            paths <- paths + Recall(p, cant, part2)
        } else {
            if(part2 && (p %in% cant)){
                paths <- paths + Recall(p, cant, FALSE)
            } else {
                paths <- paths + Recall(p, union(cant, p), part2)
            }
            
        }
        
    }
    paths
}
gg2(st = 'start', cant = NULL, part2 = FALSE)
gg2(st = 'start', cant = NULL, part2 = TRUE)


# same, takes around 5-6 sec
dfs <- function(start, seen, part_2 = FALSE){
    if(start == "end")
        return(1)
    
    s <- 0
    e2 <- to[which(from == start)]
    
    for(end in e2){
        if(!(end %in% seen)){
            tmp <- if(tolower(end) == end) end else NULL
            s <- s + Recall(end, union(seen, tmp), part_2)
        } else if (part_2){
            s <- s + Recall(end, seen, FALSE)
        }
    }
    s
}

dfs("start", NULL)
dfs("start", NULL, TRUE)