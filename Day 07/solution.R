setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(stringr)
library(purrr)

rules <- readLines("input.txt")

# Tidying
# Get bag part
tidy_rules <- str_split_fixed(rules, " contain ", 2)
bags <- gsub("\\s*bags\\s*", "", tidy_rules[,1])

bags_list <- str_match_all(tidy_rules[,2], "(\\d+) (\\w+ \\w+)")
bags_list <- setNames(lapply(bags_list, function(x) setNames(x[,2], nm = x[,3])) , 
                      bags)

ans1 <- function(bag_col){
    bags <- names(bags_list)[map_lgl(bags_list, ~bag_col %in% names(.x))]
    c(bags, unlist(lapply(bags, ans1)))
}

# Answer 1
length(unique(ans1("shiny gold")))

# Answer 2
ans2 <- function(bag_col){
    inside <- bags_list[[bag_col]]
    sum(map2_dbl(as.numeric(inside), names(inside), 
                 function(x,y) x * (1 + ans2(y)) ))
    # count bag and the items inside
}
    
ans2('shiny gold')    