library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/StateNum/Multinom/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

window_size <- c(1, 10, 20, 30, 40)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "state_num", "granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  a$window_size <- a$window_size / 30
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

for (j in window_size) {
  temp_df <- overall_df[overall_df$window_size == j,]
  plot_sim_charwise(temp_df,
                    mapping = list("color" = "state_num"),
                    adjusted = F,
                    point_or_line = NA,
                    name = paste0("Different Number of States of Multinomial Models at Window Size of ", j),
                    path)
  
}

