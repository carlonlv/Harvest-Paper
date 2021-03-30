library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/SmartHarvestComparison/"


result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes
window_size <- 750
overall_df <- data.frame()
for (i in result_files) {
  if (grepl(paste0("window_size-", window_size,","), i)) {
    a <- read.csv(i)
    a <- a[, c("granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
    overall_df <- rbind(overall_df, a)
  }
}

plot_sim_charwise(overall_df,
                  mapping = list("color" = "granularity"),
                  adjusted = FALSE,
                  point_or_line = NA,
                  name = paste0("Different Number of cores at Window Size of ", window_size / 30, " with Multinomal"),
                  path)
