library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/Granularity/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

### window_size of 1
window_size <- 20
name <- "Markov"

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size == window_size,]
  a <- a[a$name == name,]
  overall_df <- rbind(overall_df, a)
}
plot_sim_charwise(overall_df,
                  mapping = list("color" = "granularity"),
                  adjusted = TRUE,
                  point_or_line = NA,
                  name = paste0("Adjusted Different Number of cores at Window Size of ", window_size, " with ", name),
                  path)
