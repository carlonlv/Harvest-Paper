library(DataCenterSim)
library(dplyr)
library(ggplot2)

library(glmnet)

load("~/Documents/PDSF Dataset/microsoft_traces_labels.rda")

path = "~/Documents/GitHub/SimulationResult/AdHocAnalysis/"

result_files_prediction_statistics <- list.files(path, pattern = "Paramwise Prediction Statistics", full.names = TRUE, recursive = TRUE)
result_files_prediction_quantiles <- list.files(path, pattern = "Paramwise Simulation", full.names = TRUE, recursive = TRUE)

## Window Size, Granularity
window_size <- c(50)
granularity <- 3.125

for (j in 1:length(window_size)) {
  locator <- c(paste0("window_size-", window_size[j], ","), paste0("granularity-", granularity, ","))
  string_constraints_statistics <- result_files_prediction_statistics
  string_constraints_quantiles <- result_files_prediction_quantiles
  for (i in locator) {
    string_constraints_statistics <- grep(i, string_constraints_statistics, value = TRUE)
    string_constraints_quantiles <- grep(i, string_constraints_quantiles, value = TRUE)
  }

  if (length(string_constraints_statistics) != 1 | length(string_constraints_quantiles) != 1) {
    stop("Constraints are not unique.")
  }

  prediction_statistics <- read.csv(string_constraints_statistics, row.names = 1)
  prediction_quantiles <- read.csv(string_constraints_quantiles, row.names = 1)

  cut_off_prob <- 1 - 0.9999
  target <- 0.99
  labeled_prediction_information <- label_performance_trace(prediction_quantiles, cut_off_prob, target = target, predict_info_statistics = prediction_statistics)

  prediction_quantiles <- labeled_prediction_information$predict_info_quantiles
  prediction_statistics <- labeled_prediction_information$predict_info_statistics

  model <- glmnet(x = prediction_statistics[, -which(colnames(prediction_statistics) %in% c(paste0("label.", 1 - cut_off_prob), "trace_name"))],
         y = factor(prediction_statistics[, which(colnames(prediction_statistics) == paste0("label.", 1 - cut_off_prob))]),
         family = "multinomial",
         alpha = 1,
         type.multinomial = "ungrouped")


}
