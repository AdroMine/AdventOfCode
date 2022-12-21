setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

input <- read.table('sample.txt', sep = ":")
input <- read.table('input.txt', sep = ":")

input[] <- lapply(input[], trimws)
strs <- setNames(input$V2, input$V1)

idx <- which(grepl('^\\d+$', input$V2))
while(TRUE){
    if(length(idx) == 0) break
    for(i in idx){
        
        nm <- input[i, 1]
        num <- input[i, 2]
        
        input$V2 <- gsub(nm, num, input$V2)
    }
    complete_nums <- which(grepl('^\\d+ [\\+\\-\\*\\/] \\d+$', input$V2, perl = TRUE))
    for(i in complete_nums){
        input[i, 2] <- eval(parse(text = input[i, 2]))
    }
    idx <- complete_nums
}

root_key <- which(input$V1 == 'root')
input[root_key, 2]

# Part 2 
# input <- read.table('sample.txt', sep = ":")
input <- read.table('input.txt', sep = ":")

input[] <- lapply(input[], trimws)
strs <- setNames(input$V2, input$V1)
strs['humn'] <- 'X'

strs['root'] <- gsub("[\\+\\-\\*\\/]","==",strs['root'], perl = TRUE)

operators <- paste("\\+", '\\-', '\\*', '\\/', '\\=\\=', sep = '|')
while(TRUE){
    idx <- which(grepl('^\\d+$', strs))
    if(length(idx) == 0) break
    for(i in idx){
        
        nm <- names(strs)[i]
        num <- strs[i]
        
        strs <- gsub(nm, num, strs)
    }
    complete_nums <- which(
        grepl(paste0('^\\d+ (', operators, ') \\d+$'), strs, perl = TRUE)
    )
    for(i in complete_nums){
        strs[i] <- eval(parse(text = strs[i]))
    }
    strs <- strs[-idx]
}

# add brackets
strs <- gsub("(.*)", "(\\1)", strs)

root <- strs['root']
while(TRUE){
    root_symbols <- stringr::str_match(root, '[a-z]+')
    if(anyNA(root_symbols)) break
    for(s in root_symbols){
        root <- gsub(s, strs[s], root)
    }
}

root

.f <- function(X) eval(parse(text = root))

uniroot(.f, interval = c(-1e13, 1e13))