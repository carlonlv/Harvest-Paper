library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/GoogleCPUSimResult/AR1/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

### window_size of 1
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 3.125

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("window_size", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  a[, "dataset"] <- "Google"
  overall_df <- rbind(overall_df, a)
}

path2 = "~/Documents/GitHub/SimulationResult/AdHocAnalysis/AR1/"
result_files2 <- list.files(path2, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)
for (j in result_files2) {
  a <- read.csv(j)
  a <- a[, c("window_size", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  a[, "dataset"] <- "Microsoft"
  overall_df <- rbind(overall_df, a)
}


plot_sim_charwise(overall_df,
                  mapping = list("color" = "window_size", "linetype" = "dataset"),
                  adjusted = FALSE,
                  point_or_line = NA,
                  name = paste0("AR1 Model on Google and Microsoft datasets with Granularity ", granularity),
                  path)
