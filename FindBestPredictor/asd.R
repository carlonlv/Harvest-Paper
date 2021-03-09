library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:2016)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:2016)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638)]]


## Finding best predictor using ARIMA, LM, Markov
window_size <- c(1, 5, 10, 15, 20, 25)

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)
additional_setting <- list("cut_off_prob" = cut_off_prob)
## Baseline max to max, same window sizes
bg_param_setting <- data.frame(class = "ARIMA", name = "AR1", window_size = window_size, granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/AR1/")

bg_param_setting <- data.frame(class = "MARKOV", name = "Markov", window_size = window_size, granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/Markov/")

## Adding Averages
bg_param_setting <- data.frame(class = "ARIMA", name = "AR1X(Avg)", window_size = window_size, window_size_for_reg = window_size, window_type_for_reg = "avg", granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/AR1/")

bg_param_setting <- data.frame(class = "MARKOV", name = "MarkovX(Avg)", window_size = window_size, window_size_for_reg = window_size, window_type_for_reg = "avg", granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/Markov/")

bg_param_setting <- data.frame(class = "LM", name = "LM(Avg)", window_size = window_size, window_size_for_reg = window_size, window_type_for_reg = "avg", granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/LM/")

## Adding past window size of 12
additional_setting <- list("cut_off_prob" = cut_off_prob, "window_size_for_reg" = 12, "window_type_for_reg" = "max")
bg_param_setting <- data.frame(class = "ARIMA", name = "AR1X(Avg.Max12)", window_size = window_size, window_size_for_reg = window_size, window_type_for_reg = "avg", granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, list("avg" = microsoft_avg_10000, "max_12" = microsoft_max_10000), cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/AR1/")

bg_param_setting <- data.frame(class = "MARKOV", name = "MarkovX(Max12)", window_size = window_size, granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_max_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/Markov/")

#bg_param_setting <- data.frame(class = "LM", name = "LM(Avg.Max12)", window_size = window_size, window_size_for_reg = window_size, window_type_for_reg = "avg", granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
#d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, list("avg" = microsoft_avg_10000, "max_12" = microsoft_max_10000), cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/LM/")
