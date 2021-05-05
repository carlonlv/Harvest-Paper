library(DataCenterSim)
library(dplyr)
library(stringr)

path = "~/Documents/GitHub/SimulationResult/MultipleorSmallerJobs/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

### window_size of 1
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 3.125

for (w in window_size) {
  overall_df <- data.frame()
  for (i in result_files) {
    a <- read.csv(i)
    a <- a[, c("name", "window_size", "granularity", "schedule_setting", "quantile", grep("score", colnames(a), value = TRUE))]
    a <- a[a$window_size == w,]
    a <- a[a$granularity == granularity,]
    overall_df <- rbind(overall_df, a)
  }
  overall_df <- overall_df[str_order(overall_df$schedule_setting),]
  plot_sim_charwise(overall_df,
                    mapping = list("color" = "schedule_setting"),
                    adjusted = FALSE,
                    point_or_line = NA,
                    name = paste0("Different Schedule Policies with Granularity ", granularity, " Window Size", w),
                    path)
}
