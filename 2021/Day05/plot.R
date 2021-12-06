library(dplyr)
library(tidyr)
library(ggplot2)
df <- read.table("input.txt", sep = " ", col.names = c("start", "op", "end")) %>% 
    as_tibble() %>% 
    select(-op) %>% 
    separate(start, into = c("x1", "y1")) %>% 
    separate(end, into = c("x2", "y2")) %>% 
    mutate(Category = case_when(
        x1 == x2 ~ "vertical", 
        y1 == y2 ~ "horizontal", 
        TRUE ~ "diagonal"
    )) %>% 
    mutate(across(c(x1:y2), as.integer))

ggplot(df, aes(x = x1, y = y1, xend = x2, yend = y2, colour = Category)) + 
    geom_segment(alpha = 0.5, show.legend = FALSE) + 
    theme_minimal() + 
    guides(colour = guide_legend(override.aes = list(alpha = 1))) + 
    scale_color_brewer(palette = "Dark2") + 
    theme(panel.grid = element_blank(), 
          axis.line = element_blank(), 
          axis.text = element_blank(), 
          plot.background = element_rect(fill = "white"), 
          axis.title = element_blank())
    
ggsave("plot.png", width = 6, height = 6, dpi = 300)
