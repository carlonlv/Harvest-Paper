library(DataCenterSim)
library(dplyr)

path = "~/Documents/SimulationResult/NN/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

### window_size of 1
window_size <- c(1, 10, 15, 20, 25)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "window_size", "react_speed", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

for (j in window_size) {
  temp_overall_df <- overall_df[overall_df$window_size == j,]
  plot_sim_charwise(temp_overall_df,
                    mapping = list("color" = "name"),
                    adjusted = TRUE,
                    point_or_line = NA,
                    name = paste0("AR1 Model with Different React Speed at Window Size of ", j, " with Granularity ", granularity),
                    path)
}
