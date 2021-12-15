library(igraph)
g <- igraph::make_lattice(c(width, width)) %>% 
    as.directed(mode = "mutual")
E(g)$weight <- graph[get.edgelist(g)[,2]]
E(g)$weight <- graph[get.edgelist(g)[,2]]


distances(g, 1, 500 * 500, 'out', algorithm = "dijkstra")
