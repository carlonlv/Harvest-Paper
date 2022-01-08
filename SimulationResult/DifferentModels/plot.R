library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/DifferentModels/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

### window_size of 1
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  if (any(a$name == "Markov")) {
    a <- a[a$state_num == 8,]
  } else if (any(a$name == "Multinomial")) {
    a$window_size <- a$window_size / 30
    a <- a[a$state_num == 10,]
  }
  a <- a[a$window_size %in% window_size,]
  a <- a[, c("name", "granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  overall_df <- rbind(overall_df, a)
}
overall_df <- overall_df[overall_df$granularity == granularity,]

for (j in window_size) {
  temp_df <- overall_df[overall_df$window_size == j,]
  plot_sim_charwise(temp_df,
                    mapping = list("color" = "name"),
                    adjusted = FALSE,
                    point_or_line = NA,
                    name = paste0("Various Models at Window Size of ", j),
                    path)
}

