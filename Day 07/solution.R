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
    

# Tidyverse approach
# Get inside part
# Create data frame
df <- bind_cols(bag = bags, contain)
names(df)[2:5] <- paste0("rules",1:4)

# convert to long form
df2 <- df %>% 
    pivot_longer(-bag) %>% 
    mutate(value = na_if(value, "")) %>% 
    na.omit() %>% 
    separate(value, into = c("number", "colour"), 
             convert = TRUE, extra = "merge") %>% 
    mutate(number = as.integer(str_replace(number, "no", "0")), 
           colour = gsub("^([a-z ]+) ba.*$", "\\1", colour)) %>% 
    select(-name) 

bag_list <- df2 %>% select(bag, colour, number) %>% nest(data = -bag) %>% deframe()
bag_list <- lapply(bag_list, deframe)

# Answer to part 1
k <- filter(df2, colour == "shiny gold") %>% pull(bag)
total <- k
while(length(k) > 0){
    # message("\n")
    # message(paste(k, collapse = ","))
    k <- unique(filter(df2, colour %in% k) %>% pull(bag))
    total = c(total,k)
}

length(unique(total))

filter(df2, bag == "shiny gold") %>% select(colour, number) %>% deframe()

