setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- read.fwf("input.txt", widths = rep(1, 12))
# input <- read.fwf("sample.txt", widths = rep(1,5))

getmode <- function(v) {
    ones <- sum(v)
    if(ones >= length(v)/2)
        return(1)
    return(0)
}

gamma <- paste(as.character(sapply(input, getmode)), collapse = "")
# epsilon = invert each bit of gamma
epsilon <- chartr("01", "10", gamma)

strtoi(gamma, 2) * strtoi(epsilon,2)

# Part 2
o2 <- input
co2 <- input
for(col in 1:ncol(o2)){
    common1 <- getmode(o2[[col]])
    common2 <- getmode(co2[[col]])
    
    # oxygen
    if(nrow(o2) > 1){
        o2 <- o2[o2[[col]] == common1,]
    }
    
    # CO2 scrubber
    if(nrow(co2) > 1){
        co2 <- co2[co2[[col]] != common2,]
    }
}
o2 <- paste(o2, collapse = "")
co2 <- paste(co2, collapse = "")
strtoi(o2, 2) * strtoi(co2, 2)
