library(DataCenterSim)
library(dplyr)

load("~/Documents/SimulationResult/datasets/google_production_cpu_scaled.rda")

granularity <- c(100 / 32)

window_size <- c(1, 10, 20, 30, 40, 50)

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.02, 0.03, 0.05)

additional_setting <- list("cut_off_prob" = cut_off_prob)
bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)


## AR1
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1", extrap_step = 1, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, google_max_cpu, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise", "tracewise"), plot_type = "none", result_loc = "~/SimulationResult/GoogleCPUSimResult/AR1/")


## AR1X
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1X", extrap_step = 1, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, google_max_cpu, google_avg_cpu, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/GoogleCPUSimResult/AR1X/")


## Markov
bg_param_setting <- data.frame(class = "MARKOV", name = "Markov", train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, google_max_cpu, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/GoogleCPUSimResult/Markov/")
