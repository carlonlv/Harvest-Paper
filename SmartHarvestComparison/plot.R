library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/SmartHarvestComparison/Multinom/"


result_files <- list.files(path, pattern = "Paramwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

## granulaity of 100 / 8
overall_df <- data.frame()
for (i in result_files) {
  if (grepl(paste0("granularity-", 100 / 8), i)) {
    a <- read.csv(i)
    a <- a[, c("trace_name", "quantile", grep("score", colnames(a), value = TRUE))]
    overall_df <- rbind(overall_df, a)
  }
}

View(DataCenterSim:::check_score_param(1 - unique(overall_df$quantile), overall_df))

plot_sim_paramwise(overall_df, 0.99,
                   "Multinomial Model with 8 Cores", path)
