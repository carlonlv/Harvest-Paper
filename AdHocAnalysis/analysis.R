library(DataCenterSim)
library(dplyr)
library(ggplot2)

library(glmnet)

#load("~/Documents/GitHub/PDSF Dataset/microsoft_traces_labels.rda")

path = "~/Documents/GitHub/SimulationResult/AdHocAnalysis/"

## Window Size, Granularity
window_size <- c(1, 10, 30)
granularity <- 100 / 32

target <- c(0.999, 0.99, 0.98)
cut_off_prob <- 1 - target
adjustment_policy <- list(c(0,0), c(1,1), c(1,2))

#score_change_after_buffer <- find_score_after_buffer(cut_off_prob, window_size, granularity, 30, adjustment_policy, cores = parallel::detectCores(), path)
plot_score_change_with_buffer(score_change_after_buffer, adjustment_policy, window_size, granularity, "with Granularity 3.125", "~/Documents/GitHub/SimulationResult/AdHocAnalysis/")

#extra_margin_lst <- find_extra_margin(target, cut_off_prob, window_size, granularity, adjustment_policy, parallel::detectCores() - 1, path)
#plot_buffer_needed_to_reach_target(extra_margin_lst, adjustment_policy, window_size, granularity, target, name = "Extra Buffer to Reach Target", path)

#score_change_info_list <- find_score_change(cut_off_prob, target, window_size, granularity, path, adjustment = FALSE)
#plot_trace_removal_information(score_change_info_list, cut_off_prob, target, window_size, granularity, F, "AR1 Model with Granularity of 3.125 Cut off Prob (0.999-0.99)", path)
