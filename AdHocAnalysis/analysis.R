library(DataCenterSim)
library(dplyr)
library(ggplot2)

library(glmnet)

load("~/Documents/PDSF Dataset/microsoft_traces_labels.rda")

path = "~/Documents/GitHub/SimulationResult/AdHocAnalysis/"

result_files_prediction_statistics <- list.files(path, pattern = "Paramwise Prediction Statistics", full.names = TRUE, recursive = TRUE)
result_files_prediction_quantiles <- list.files(path, pattern = "Paramwise Simulation", full.names = TRUE, recursive = TRUE)

## Window Size, Granularity
window_size <- c(10, 20, 30, 40, 50)
granularity <- 3.125

traces_removed <- data.frame()
score_change <- data.frame()

traces_removed_adj <- data.frame()
score_change_adj <- data.frame()

for (j in 1:length(window_size)) {
  locator <- c(paste0("window_size-", window_size[j], ","), paste0("granularity-", granularity, ","))
  string_constraints_quantiles <- result_files_prediction_quantiles
  for (i in locator) {
    string_constraints_quantiles <- grep(i, string_constraints_quantiles, value = TRUE)
  }

  if (length(string_constraints_quantiles) != 1) {
    stop("Constraints are not unique.")
  }

  prediction_quantiles <- read.csv(string_constraints_quantiles, row.names = 1)

  cut_off_prob <- 1 - 0.9999
  target <- 0.99
  labeled_prediction_information <- label_performance_trace(prediction_quantiles, cut_off_prob, target = target, predict_info_statistics = NULL)

  prediction_quantiles <- labeled_prediction_information$predict_info_quantiles

  removal_information <- calc_removal_to_reach_target(prediction_quantiles, cut_off_prob, target = target, adjustment = FALSE)
  traces_removed <- rbind(traces_removed, data.frame("trace_removed" = removal_information$trace_removed, "window_size" = window_size[j], "granularity" = granularity))
  removal_information$score_change[, "window_size"] <- window_size[j]
  removal_information$score_change[, "num_traces_removed"] <- 0:(nrow(removal_information$score_change) - 1)
  removal_information$score_change[, "granularity"] <- granularity
  score_change <- rbind(score_change, removal_information$score_change)

  removal_information_adj <- calc_removal_to_reach_target(prediction_quantiles, cut_off_prob, target = target, adjustment = TRUE)
  traces_removed_adj <- rbind(traces_removed_adj, data.frame("trace_removed" = removal_information_adj$trace_removed, "window_size" = window_size[j], "granularity" = granularity))
  removal_information_adj$score_change[, "window_size"] <- window_size[j]
  removal_information_adj$score_change[, "num_traces_removed"] <- 0:(nrow(removal_information_adj$score_change) - 1)
  removal_information_adj$score_change[, "granularity"] <- granularity
  score_change_adj <- rbind(score_change_adj, removal_information_adj$score_change)
}

plt1 <- ggplot2::ggplot(score_change, ggplot2::aes(x = num_traces_removed, y = score1_adj.n, colour = factor(window_size))) +
  ggplot2::geom_path(na.rm = TRUE) +
  ggplot2::ylab("Score1 After Removal") +
  ggplot2::xlab("Number of Traces Removed") +
  ggplot2::theme_bw() +
  ggsci::scale_color_ucscgb(name = "window size") +
  ggplot2::theme(legend.position = c(0.25, 0.75), legend.background = ggplot2::element_rect(fill = "white", color = "black"))


plt2 <- ggplot2::ggplot(score_change, ggplot2::aes(x = num_traces_removed, y = score2_adj.n, colour = factor(window_size))) +
  ggplot2::geom_path(na.rm = TRUE) +
  ggplot2::ylab("Score2 After Removal") +
  ggplot2::xlab("Number of Traces Removed") +
  ggplot2::theme_bw() +
  ggsci::scale_color_ucscgb(name = "window size") +
  ggplot2::theme(legend.position = c(0.25, 0.75), legend.background = ggplot2::element_rect(fill = "white", color = "black"))


plt3 <- ggplot2::ggplot(score_change_adj, ggplot2::aes(x = num_traces_removed, y = score1_adj.n, colour = factor(window_size))) +
  ggplot2::geom_path(na.rm = TRUE) +
  ggplot2::ylab("Score1 (Adj) After Removal") +
  ggplot2::xlab("Number of Traces Removed") +
  ggplot2::theme_bw() +
  ggsci::scale_color_ucscgb(name = "window size") +
  ggplot2::theme(legend.position = c(0.25, 0.75), legend.background = ggplot2::element_rect(fill = "white", color = "black"))


plt4 <- ggplot2::ggplot(score_change_adj, ggplot2::aes(x = num_traces_removed, y = score2_adj.n, colour = factor(window_size))) +
  ggplot2::geom_path(na.rm = TRUE) +
  ggplot2::ylab("Score2 (Adj) After Removal") +
  ggplot2::xlab("Number of Traces Removed") +
  ggplot2::theme_bw() +
  ggsci::scale_color_ucscgb(name = "window size") +
  ggplot2::theme(legend.position = c(0.25, 0.75), legend.background = ggplot2::element_rect(fill = "white", color = "black"))

