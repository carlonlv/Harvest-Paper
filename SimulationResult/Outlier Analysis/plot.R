library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/Outlier Analysis/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes
## 10, 20, 30, 40, 50
window_size <- 50

## Categorical, Categorical-Dirichlet
outlier_prediction <- "Categorical-Dirichlet"

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("granularity", "outlier_prediction", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size == window_size,]
  a <- a[a$outlier_prediction == outlier_prediction,]
  overall_df <- rbind(overall_df, a)
}
plot_sim_charwise(overall_df,
                  mapping = list("color" = "granularity"),
                  adjusted = TRUE,
                  point_or_line = NA,
                  name = paste0("AR1 Model with Window Size of ", window_size, " using ", outlier_prediction, " Oulier Adjustment Procedure"),
                  path)
