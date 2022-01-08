library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 32)

window_size <- c(1, 10, 15, 20, 30)

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05)

react_speed <- c("1,1", "1,2", "1,3", "2,1", "2,2", "2,3", "2,4", "2,5")

additional_setting <- list("cut_off_prob" = cut_off_prob)

bg_param_setting <- expand.grid(granularity = granularity, react_speed = react_speed, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1", train_policy = "fixed", train_size = 2000, update_freq = 3, extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/AdjustmentPolicy/AR1/")

bg_param_setting <- expand.grid(granularity = granularity, react_speed = react_speed, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "MARKOV", name = "Markov", train_policy = "fixed", train_size = 2000, update_freq = 3, extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/AdjustmentPolicy/Markov/")
