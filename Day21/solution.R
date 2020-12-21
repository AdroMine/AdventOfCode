setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(purrr)
input <- readLines("input.txt")
ingredients <- strsplit(input, "\\(contains ")

allrg <- lapply(ingredients, pluck, 2)
allrg <- lapply(allrg, gsub, pattern = "\\)", replacement = "")
allrg <- lapply(allrg, function(x) strsplit(x, ", ")[[1]])

ingrd <- lapply(ingredients, pluck, 1)
ingrd <- lapply(ingrd, function(x) strsplit(x, " ")[[1]])

all_ingredients <- unique(unlist(ingrd))
recipe <- new.env()

for(i in seq_along(ingrd)){
    algn <- allrg[[i]]
    ing <- ingrd[[i]]
    for(a in algn){
        if(!exists(a, envir = recipe)){
            recipe[[a]] <- ing
        } else{
            recipe[[a]] <- intersect(recipe[[a]], ing)
        }
    }
}

allergens <- as.list(recipe)
contain_allergen <- unname(unlist(allergens))
no_allergen <- setdiff(all_ingredients, contain_allergen)

# Part 1
sum(table(unlist(ingrd))[no_allergen])


final_list <- rep(NA, length(allergens))
names(final_list) <- names(allergens)

l <- lapply(allergens, length)
while(any(l > 0)){
    x <- which(l == 1)[1]
    p <- allergens[[x]]
    final_list[names(x)] <- p
    allergens <- lapply(allergens[-x], setdiff, p)
    l <- lapply(allergens, length)
}

ord <- order(names(final_list))
# Part 2
paste(final_list[ord], collapse = ",")

