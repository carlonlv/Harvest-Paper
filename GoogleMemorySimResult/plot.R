library(DataCenterSim)
library(dplyr)

path = "~/Documents/SimulationResult/GoogleMemorySimResult/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

### window_size of 1
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "window_size", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  overall_df <- rbind(overall_df, a)
}

plot_sim_charwise(overall_df,
                  mapping = list("color" = "window_size", "linetype" = "name"),
                  adjusted = FALSE,
                  point_or_line = NA,
                  name = paste0("Different Models with Google datasets with Granularity ", granularity),
                  path)
