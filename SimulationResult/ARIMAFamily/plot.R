library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/ARIMAFamily"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

window_size <- 50
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "granularity", "window_size", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size == window_size,]
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

plot_sim_charwise(overall_df,
                  mapping = list("color" = "name"),
                  adjusted = F,
                  point_or_line = NA,
                  name = paste0("Different ARIMA Models at Window Size of ", window_size),
                  path)
