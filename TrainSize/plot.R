library(DataCenterSim)
library(dplyr)

path = "~/Documents/GitHub/SimulationResult/TrainSize/"

result_files <- list.files(path, pattern = "Charwise*", full.names = TRUE, recursive = TRUE)

## Baseline max to max, same window sizes

### window_size of 1
window_size <- c(1, 10, 15, 20)
granularity <- 3.125

model_names <- c("VAR1", "AR1", "AR1X(avg)", "Markov(Max-Max)", "Markov(Avg-Max)")

overall_df <- data.frame()
for (i in result_files) {
  a <- read.csv(i)
  a <- a[, c("name", "window_size", "train_size", "train_policy", "granularity", "quantile", grep("score", colnames(a), value = TRUE))]
  a <- a[a$window_size %in% window_size,]
  a <- a[a$granularity == granularity,]
  a <- a[a$train_policy == "fixed",]
  a <- a[a$name %in% model_names,]
  a$train_size <- floor(a$train_size / a$window_size)
  overall_df <- rbind(overall_df, a)
}

asd <- expand.grid(window_size = window_size, model_names = model_names, stringsAsFactors = F)
for (j in 1:nrow(asd)) {
  temp_overall_df <- overall_df[overall_df$window_size == asd[j, "window_size"] & overall_df$name == asd[j, "model_names"],]
  plot_sim_charwise(temp_overall_df,
                    mapping = list("color" = "train_size"),
                    adjusted = FALSE,
                    point_or_line = NA,
                    name = paste0(asd[j, "model_names"], " with Different Training Sizes at Window Size of ", asd[j, "window_size"], " with Granularity ", granularity),
                    path)
}
