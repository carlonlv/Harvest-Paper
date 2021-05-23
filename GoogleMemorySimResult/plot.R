library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/GoogleMemorySimResult/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

### window_size of 1
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 0

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "window_size", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

for (kk in window_size) {
  temp_df <- overall_df[overall_df$window_size == kk,]
  plot_sim_charwise(temp_df,
                    mapping = list("color" = "name"),
                    adjusted = FALSE,
                    point_or_line = NA,
                    name = paste0("Different Models with Window Size ", kk, " with Granularity ", granularity),
                    path)
}

