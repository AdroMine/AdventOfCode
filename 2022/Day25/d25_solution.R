setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(magrittr)

# in_file <- 'sample.txt'
in_file <- 'input.txt'

input <- readLines(in_file)

to_decimal <- function(snafu){
    snafu <- strsplit(snafu, '')[[1]]
    snafu <- gsub('-', '-1', snafu)
    snafu <- gsub('=', '-2', snafu)
    snafu <- rev(as.integer(snafu))
    sum(5^seq.int(0, length.out = length(snafu)) * snafu)
}

to_snafu <- function(num){
    
    conv <- c('4' = '-', '3' = '=', '0' = 0, '1'=1, '2' = 2)
    new_num <- c()
    while(num > 0){
        d <- num %/% 5
        m <- num %% 5
        new_num <- c(new_num, conv[as.character(m)])
        if(m >= 3) d <- d + 1
        num <- d
    }
    
    paste(rev(new_num), collapse = "")
    
}

sapply(input, to_decimal) %>% 
    sum() %>% 
    to_snafu()
