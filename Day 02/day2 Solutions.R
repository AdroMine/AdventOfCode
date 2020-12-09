library(dplyr)
library(tidyr)
library(stringi)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

input <- read.table("input.txt", sep = " ")

input <- input %>% 
    separate(V1, into = c("min", "max"), sep = "-", convert = TRUE) %>% 
    mutate(V2 = substr(V2, 1, 1),
           count_char = stri_count_fixed(V3, V2), 
           valid1 = count_char >= min & count_char <=max, 
           pos1 = substr(V3, min, min) == V2, 
           pos2 = substr(V3, max, max) == V2, 
           valid2 = xor(pos1, pos2))  

sum(input$valid1)
sum(input$valid2)


library(data.table)
library(stringi)
inp <- fread("input.txt", sep = " ", header = FALSE)
inp[, V2:= substr(V2, 1, 1)]

# Part 1
inp[,c("min", "max"):= lapply(tstrsplit(V1, "-", fixed = TRUE), as.numeric)]
inp[, char_count:= stri_count_fixed(V3, V2)]
inp[, valid:= ifelse(char_count >= min & char_count <= max, "Valid", "Invalid")]
inp[, .N, by= valid]

# Part 2
inp[, pos1:= substr(V3, min, min) == V2]
inp[, pos2:= substr(V3, max, max) == V2]
inp[, valid2:= xor(pos1, pos2)]
inp[, .N, by = valid2]

