library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 32)

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05)

train_size <- c(1000, 1250, 1500, 1750)

train_policy <- c("offline", "fixed")

window_size <- c(1, 10, 15, 20)

additional_setting <- list("cut_off_prob" = cut_off_prob)

for (i in train_size) {
  
  bg_param_setting <- expand.grid(window_size = window_size, train_policy = train_policy, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1", granularity = granularity, train_size = i, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  bg_param_setting$window_size_for_xreg <- bg_param_setting$window_size
  bg_param_setting$window_type_for_xreg <- "avg"
  d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, start_point = 2000 - i + 1, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/TrainSize/AR1/")
  
  bg_param_setting <- expand.grid(window_size = window_size, train_policy = train_policy, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1X(avg)", granularity = granularity, train_size = i, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  d <- run_sim(bg_param_setting,additional_setting,  microsoft_max_10000, microsoft_avg_10000, start_point = 2000 - i + 1, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/TrainSize/AR1X/")
  
  bg_param_setting <- expand.grid(window_size = window_size, train_policy = train_policy, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting, data.frame(name = "MARKOV", name = "Markov", granularity = granularity, train_size = i, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  d <- run_sim(bg_param_setting,additional_setting,  microsoft_max_10000, NULL, start_point = 2000 - i + 1, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/TrainSize/Markov/")
  
  bg_param_setting <- expand.grid(window_size = window_size, train_policy = train_policy, cluster_type = c("fixed", "quantile"), stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting, data.frame(name = "MARKOV", name = "Markov(quantile)", cluster_type = "quantile", granularity = granularity, train_size = i, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, start_point = 2000 - i + 1, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/TrainSize/MarkovX/")
  
  bg_param_setting <- expand.grid(window_size = window_size, train_policy = train_policy, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting, data.frame(class = "VAR", name = "VAR1", p = 1, granularity = granularity, train_size = i, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  bg_param_setting$window_size_for_xreg <- bg_param_setting$window_size
  bg_param_setting$window_type_for_xreg <- "avg"
  d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, start_point = 2000 - i + 1, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/TrainSize/VAR1/")
}