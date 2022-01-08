library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/AdjustmentPolicy/Markov/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

### window_size of 1
window_size <- 20
#granularity <- c(6.250000, 3.125000, 2.083333, 1.562500)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("window_size", "react_speed", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size == window_size,]
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

temp_00 <- overall_df[overall_df$react_speed == "1,1",]
temp_00$react_speed <- "0,0"
temp_00[, c("score1_adj.n", "score1_adj.w", "score2_adj.n", "score2_adj.w")] <- temp_00[, c("score1.n", "score1.w", "score2.n", "score2.w")]
overall_df <- rbind(temp_00, overall_df)

plot_sim_charwise(overall_df,
                  mapping = list("color" = "react_speed"),
                  adjusted = TRUE,
                  point_or_line = NA,
                  name = paste0("Markov Model with Different React Speed at Window Size of ", window_size, " with Granularity ", granularity),
                  path)
