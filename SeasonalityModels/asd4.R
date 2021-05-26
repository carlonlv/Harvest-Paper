library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 32)

window_size <- c(1)

freq <- 12

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05)

additional_setting <- list("cut_off_prob" = cut_off_prob)

## SAR1
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "SAR(1)(1)", freq = freq, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
additional_setting$train_args <- list("order" = c(1,0,0), "seasonal" = c(1,0,0))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/ARIMAFamily/")

## SAR2
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "SAR(2)(1)", freq = freq, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
additional_setting$train_args <- list("order" = c(2,0,0), "seasonal" = c(1,0,0))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/ARIMAFamily/")

## SARMA (1,1)
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "SARMA(1.1)(1)", freq = freq, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
additional_setting$train_args <- list("order" = c(1,0,1), "seasonal" = c(1,0,0), "train_args" = list("optim.method" = "BFGS", "method" = "ML"))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/ARIMAFamily/")

## SARIMA (1,1,1)
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "SARIMA(1.1.1)(1)", freq = freq, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
additional_setting$train_args <- list("order" = c(1,1,1), "seasonal" = c(1,0,0), "train_args" = list("optim.method" = "BFGS", "method" = "ML"))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/ARIMAFamily/AR1/")

## AutoSARIMA
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "AUTO_ARIMA", name = "SARIMA(auto)", freq = freq, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/ARIMAFamily/")
