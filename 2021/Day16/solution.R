setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
# library(R.utils)
library(magrittr)


# Read and Transform input ------------------------------------------------
file_name <- "input.txt"
input <- readLines(file_name)       # read text
    
hextobin <- function(input){
    input %>%     
        strsplit("") %>%          # separate into characters
        `[[`(1) %>%               # returns list, so take the first element (that is the whole input)
        strtoi(base = 16) %>%     # convert to integers
        R.utils::intToBin() %>%   # convert to binary
        paste0(collapse = "") %>% # combine the binary strings
        strsplit("") %>%          # again split into characters
        `[[`(1)
}


# helper functions
add <- function(s) paste0(s, collapse = "")
todec <- function(s) strtoi(add(s), 2L)
ext <- function(s, st, n) s[st:(st + n -1)] 

# strtoi fails for some large binary strings
BinToDec <- function(x)  sum(2^(which(rev(unlist(strsplit(x, "")) == 1))-1))

extract_literal <- function(string, n){
    i <- n
    num <- c()
    while(string[i] == '1'){
        i <- i + 1
        num <- add(c(num, ext(string, i, 4)))
        i <- i + 4
    }
    # last number string[i] == 0
    i <- i + 1
    num <- add(c(num, ext(string, i, 4)))
    i <- i + 4
    
    list(num = BinToDec(num), i = min(i, length(string)))
}

parse_packet <- function(input, n = 1){
    
    i <- n
    
    # extract version first 3 char
    ver <- todec(ext(input, i, 3))
    i <- i + 3
    
    # extract type id, next 3 char
    type_id <- as.character(todec(ext(input,i, 3)))
    i <- i + 3
    
    if(type_id == '4'){ 
        
        # literal value
        res <- extract_literal(input, i)
        
        i <- res$i
        packet <- list(
            version = ver, 
            type_id = type_id, 
            content = res$num
        )
        
        class(packet) <- c("packet", class(packet)) # implement pretty printing for packets?
        
        return(list(
            packet = packet, 
            read_till = i
        ))
        
    } else {          
        
        #  operator
        length_type <- input[i]
        i <- i + 1
        
        # initialise list to contain all subsequent packets
        packets <- list(
            version = ver,
            type_id = type_id, 
            content = list()
        )
        class(packets) <- c("packet", class(packets))
        
        if(length_type == '0'){
            
            # If the length type ID is 0, then the next 15 bits are a number that
            # represents the total length in bits of the sub-packets contained by
            # this packet.
            
            len <- todec(ext(input, i, 15))
            i <- i + 15
            till <- i + len - 1
            item <- 1
            while(i < till){
                
                res <- parse_packet(input, i)
                i <- res$read_till
                sub_packets <- res$packet
                packets$content[paste0("packet",item)] <- list(sub_packets)
                item <- item + 1
            }
            
            return(list(
                packet = packets, 
                read_till = i
            ))
            
        } else {
            
            # If the length type ID is 1, then the next 11 bits are a number that
            # represents the number of sub-packets immediately contained by this
            # packet.
            
            len <- todec(ext(input, i, 11))
            i <- i + 11
            
            j <- 1
            while(j <=len){
                
                res <- parse_packet(input, n = i)
                i <- res$read_till
                sub_pkt <- res$packet
                packets$content[paste0("packet",j)] <- list(sub_pkt)
                j <- j + 1
            }
            
            return(list(
                packet = packets, 
                read_till = i
            ))
        }
        
        
    }
    packets
}

all_res <- parse_packet(hextobin(input))

# function to find sum of versions
version_sum <- function(packet){
    
    if(is.list(packet$content))
        return(packet$version + sum(sapply(packet$content, version_sum)))
    
    packet$version
    
}

# part1 
version_sum(all_res$packet)

# Part 2
compute_packet <- function(packet){
    
    if(packet$type_id == '4')
        return(packet$content)
    
    
    operator <- switch(packet$type_id, 
                       '0' = sum, 
                       '1' = prod, 
                       '2' = min, 
                       '3' = max, 
                       '5' = function(xy, na.rm = TRUE) as.integer(xy[1] > xy[2]), 
                       '6' = function(xy, na.rm = TRUE) as.integer(xy[1] < xy[2]), 
                       '7' = function(xy, na.rm = TRUE) as.integer(xy[1] == xy[2]))
    
    args <- c()
    for(p in packet$content)
        args <- c(args, Recall(p))
    
    do.call(operator, list(args, na.rm = TRUE))
    
}

compute_packet(all_res$packet)
