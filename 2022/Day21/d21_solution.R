setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# input <- read.table('sample.txt', sep = ":")
input <- read.table('input.txt', sep = ":")
input[] <- lapply(input[], trimws)

# which are pure numbers
idx <- which(grepl('^\\d+$', input$V2))
while(TRUE){
    # stop if no pure numbers left
    if(length(idx) == 0) break
    # for each pure number, perform replacement in all strings
    for(i in idx){
        
        nm <- input[i, 1]
        num <- input[i, 2]
        
        input$V2 <- gsub(nm, num, input$V2)
    }
    # find new pure numbers and operations
    complete_nums <- which(grepl('^\\d+ [\\+\\-\\*\\/] \\d+$', input$V2, perl = TRUE))
    # eval and convert to pure numbers  var: num
    for(i in complete_nums){
        input[i, 2] <- eval(parse(text = input[i, 2]))
    }
    # now redo loop for these
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
    # replace pure numbers
    idx <- which(grepl('^\\d+$', strs))
    
    if(length(idx) == 0) break # stop when no pure nums left
    # for each pure number, perform replacement in rest strings
    for(i in idx){
        
        nm <- names(strs)[i]
        num <- strs[i]
        
        strs <- gsub(nm, num, strs)
    }
    # which are num1 op num2
    complete_nums <- which(
        grepl(paste0('^\\d+ (', operators, ') \\d+$'), strs, perl = TRUE)
    )
    # evaluate such
    for(i in complete_nums){
        strs[i] <- eval(parse(text = strs[i]))
    }
    strs <- strs[-idx]
}

# add brackets
strs <- gsub("(.*)", "(\\1)", strs)

root <- strs['root']
# expand expressions and create equation
while(TRUE){
    root_symbols <- stringr::str_match(root, '[a-z]+')
    if(anyNA(root_symbols)) break
    for(s in root_symbols){
        root <- gsub(s, strs[s], root)
    }
}

root
root <- gsub("==", "-", root)

.f <- function(X) eval(parse(text = root))

uniroot(.f, interval = c(-1e20, 1e20))
