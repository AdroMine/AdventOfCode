setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(purrr)
library(data.table)
library(dplyr)
library(tidyr)
library(stringr)

input <- readLines("input.txt")

blanks <- cumsum(input == "")
records <- stringr::str_trim(tapply(input, blanks, paste, collapse = " "))

# Another approach

data <- lapply(str_match_all(records, "(\\w\\w\\w):([0-9a-z\\#]+)"), function(x) x[,-1])
data <- lapply(data, function(x) x %>% as_tibble() %>% tibble::deframe())

mand_fields <- c('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid')

# Part 1
sum(sapply(data, function(x) all(mand_fields %in% names(x))))

# Part 2
valid_field <- function(x){
    (
        all(mand_fields %in% names(x)) &&
            x['byr'] %in% 1920:2002 &&
            x['iyr'] %in% 2010:2020 &&
            x['eyr'] %in% 2020:2030 &&
            grepl("^#[0-9a-f]{6}", x['hcl']) && 
            ( (str_ends(x['hgt'], "cm") && str_sub(x['hgt'], end = -3L) %in% 150:193) || 
                  (str_ends(x['hgt'], 'in') && str_sub(x['hgt'], end = -3L) %in% 59:76)) &&
            x['ecl'] %in% c('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth') && 
            grepl("^[0-9]{9}$", x['pid'])
    )
    
}
sum(sapply(data, valid_field))




# ------------------------------#
# ------ Old Approach --------- #
# ------------------------------#

# Convert to table with 8 columns (each column contains key:value pairs)
df <- fread(text = records, fill = TRUE)
df[, id:= 1:nrow(df)]

# Clean data to separate key value pairs into separate columns
df2 <- df %>% 
    pivot_longer(-id, values_to = "val") %>%
    separate(val, into = c("field", "text"),sep = ":") %>% 
    na.omit() %>% 
    select(-name) %>% 
    pivot_wider(id_cols = id, names_from = field, values_from = text, values_fill = NA) %>% 
    rowwise(id) %>% 
    mutate(valid = !any(is.na(c_across(hcl:byr)))) %>% 
    ungroup() %>% 
    mutate(across(c(iyr, eyr, byr), as.numeric))

# Part 1 Solution
sum(df2$valid)

# Part 2 Solution

# function for computing if height|hgt is valid
valid_height <- function(x){
    valid <- rep(FALSE, length(x))
    which_cm <- grep("cm$", x)
    which_in <- grep("in$", x)
    valid[which_cm] <- between(as.numeric(gsub("cm", "", x[which_cm])), 150, 193)
    valid[which_in] <- between(as.numeric(gsub("in", "", x[which_in])), 59, 76)
    valid
}

# Compute validity (changing original fields)
df3 <- df2 %>% 
    mutate(across(c(iyr, eyr, byr), as.numeric)) %>% 
    mutate(byr = between(byr, 1920, 2002), 
           iyr = between(iyr, 2010, 2020), 
           eyr = between(eyr, 2020, 2030), 
           hgt = valid_height(hgt), 
           hcl = grepl("^#[0-9a-f]{6}", hcl), 
           ecl = ecl %in% c('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'), 
           pid = grepl("^[0-9]{9}$", pid)) %>% 
    select(-cid) %>% 
    rowwise(id) %>% 
    mutate(valid2 = all(c_across())) 

# Answer
sum(df3$valid2)


