library(DataCenterSim)
library(dplyr)
library(ggplot2)

library(glmnet)

load("~/Documents/PDSF Dataset/microsoft_traces_labels.rda")

path = "~/Documents/Github/SimulationResult/AdHocAnalysis/"

## Window Size, Granularity
window_size <- c(1, 10, 20, 30, 40, 50)
granularity <- 3.125

target <- c(0.999, 0.995, 0.99)
cut_off_prob <- 1 - target

find_extra_margin(target, cut_off_prob, window_size, granularity, path)


score_change_info_list <- find_score_change(cut_off_prob, target, window_size, granularity, path, adjustment = FALSE)
plot_trace_removal_information(score_change_info_list, cut_off_prob, target, window_size, granularity, F, "AR1 Model with Granularity of 3.125 Cut off Prob (0.999-0.99)", path)
