setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in input
input <- read.table("input.txt", sep = "|")
input$V1 <- trimws(input$V1)
input$V2 <- trimws(input$V2)

# Part 1 ------------------------------------------------------------------
count <- 0
for(i in 1:nrow(input)){
    inp <- strsplit(input$V2[i], " ")[[1]]
    len <- nchar(inp)
    count <- count + sum(len %in% c(2, 4, 3, 7))
}
count


# Part 2 ------------------------------------------------------------------


# some helper functions

# split word into characters
chars <- function(str){
    strsplit(str, "")[[1]]
}

# generate grep pattern
both <- function(chr){
    x <- chr[1]
    y <- chr[2]
    as.character(glue::glue("{x}.*{y}|{y}.*{x}"))
}

# characters of x in y?
char_in <- function(x, y, not = FALSE){
    x <- chars(x)
    y <- chars(y)
    if(not) x[!x %in% y] else x[x %in% y]
}

#     1
#   -----
#  |     |  
# 6|     | 2
#  |  7  | 
#   -----
#  |     | 
# 5|     | 3
#  |     |  
#   -----
#     4
# 

# will represent the digits with the above integers

decode <- function(s, o){
    
    # create empty vector of positions that characters will take
    digits_pos <- vector("character", length = 7)
    
    # determine unique digits
    lens <- nchar(s)
    d1 <- s[which(lens == 2)]
    d4 <- s[which(lens == 4)]
    d7 <- s[which(lens == 3)]
    d8 <- s[which(lens == 7)]
    
    # determined final pos of d1 digit (see above diagram for indices)
    digits_pos[1] <- char_in(d7, d1, TRUE)
    
    
    # determine 2, 3, 5 (5 char digits)
    cand_235 <- s[which(lens == 5)]
    
    # 3 will contain both digits of d1 (2 & 5 won't)
    d3 <- grep(both(chars(d1)), cand_235, value = TRUE)
    
    # from 3 we find out the 6th and 7th index
    
    # 7th index = char in both 3 and 4 but not in one
    digits_pos[7] <- intersect(chars(d3), 
                               setdiff(chars(d4), chars(d1)))
    
    # 6th index = unique char in 4 that are not in digits_pos already
    digits_pos[6] <- setdiff(setdiff(chars(d4), chars(d1)), digits_pos[7])
    
    # 5 contains both unique digits of d4 (not in d1)
    d5 <- grep(both(setdiff(chars(d4), chars(d1))), 
                 setdiff(cand_235, d3), value = TRUE)
    
    # from 5 we determine the indices of 2, 3, 4, 5
    digits_pos[3] <- char_in(d5, d1) # char in 5 and 1
    digits_pos[2] <- char_in(d1, digits_pos[3], TRUE) # char in 1 not in 3
    digits_pos[4] <- setdiff(chars(d5), digits_pos) # char in 5 not accounted for by now
    digits_pos[5] <- setdiff(letters[1:7], digits_pos) # the final letter left
    
    # 2 is the candidate left in cand_235
    d2 <- setdiff(cand_235, c(d3, d5))
    
    # candidates for 6, 9 and 0
    cand_960 <- s[which(lens == 6)]
    
    # 6 does not contain 2nd index from the 7 digit 
    d6 <- grep(digits_pos[2], cand_960, invert = TRUE, value = TRUE)
    
    # 9 does not contain 5th index
    g9 <- grep(digits_pos[5], cand_960, invert = TRUE, value = TRUE)
    
    # 0 does not contain 7th index
    d0 <- grep(digits_pos[7], cand_960, invert = TRUE, value = TRUE)
    
    # set of characters for the different digits
    mapping <- c(d0, d1, d2,  d3, d4, d5, d6, d7, d8, g9)
    mapping <- lapply(mapping, chars)
    
    num <- ""
    for(word in o){
        word <- chars(word)
        for(j in 1:10){
            if(setequal(word, mapping[[j]]))
                break
        }
        num <- paste0(num, j-1) # index starts at 1 we want 0
    }
    as.numeric(num)
    
}
    

count <- 0
for(i in 1:nrow(input)){
    inp <- strsplit(input$V1[i], " ")[[1]]
    opt <- strsplit(input$V2[i], " ")[[1]]
    count <- count + decode(inp, opt)
}
count
