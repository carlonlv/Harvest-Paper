library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/StateNum/Markov"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

window_size <- 1
granularity <- 3.125
cluster_type <- "fixed"

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "state_num", "cluster_type", "granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size == window_size,]
  a <- a[a$granularity == granularity,]
  a <- a[a$cluster_type == cluster_type,]
  overall_df <- rbind(overall_df, a)
}

plot_sim_charwise(overall_df,
                  mapping = list("color" = "state_num"),
                  adjusted = F,
                  point_or_line = NA,
                  name = paste0("Different Number of States of Markov Models (fixed partitioning) at Window Size of ", window_size),
                  path)
