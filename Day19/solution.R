setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(purrr)

transform_rules <- function(rule){
    rule <- gsub('\"a\"', "a", rule)
    rule <- gsub('\"b\"', "b", rule)
    rule <- gsub("(\\d+)", ":\\1:", rule)
    
    while(any(grepl("\\d", rule))){
        
        ids <- names(rule)[grep("\\d+", rule, invert = TRUE)]          # rules without numbers
        
        rule[ids] <- gsub(" ","", rule[ids])
        for(id in ids){
            k <- rule[id]
            if(nchar(k) > 1)
                k <- sprintf("(%s)", k)
            rule <- gsub(pattern     = sprintf(":%s:", id), 
                         replacement = k, 
                         x = rule)
        }
    }
    rule <- gsub("^", "^", rule)
    rule <- gsub("$", "$", rule)
    rule <- gsub(" ", "", rule)
    rule
}

input <- readLines("input.txt")

mark <- which(input == "")
msg <- input[(mark+ 1): length(input)]

rules <- strsplit(input[1: (mark - 1)], ": ", fixed = TRUE)
rule_id <- as.numeric(map_chr(rules, pluck, 1))
rule <- map_chr(rules, pluck, 2)[order(rule_id)]
names(rule) <- sort(rule_id)

# Part 1
rule1 <- transform_rules(rule)
sum(grepl(rule1['0'], msg, perl = TRUE))

rule['8'] <- "42+"
rule['11'] <- "(?P<eleven> 42 (?&eleven)? 31)"

rule <- transform_rules(rule)
sum(grepl(rule['0'], msg, perl = TRUE))

