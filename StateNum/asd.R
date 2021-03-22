library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 32,  100 / 48)

window_size <- c(1, 10, 15, 20)

state_num <- c(8, 10, 16, 20)

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05)

additional_setting <- list("cut_off_prob" = cut_off_prob)

bg_param_setting <- expand.grid(granularity = granularity, state_num = state_num, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "MARKOV", name = "Markov", train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/StateNum/Markov/")

load("~/microsoft_generated_data_3000.rda")
microsoft_generated_data_3000 <- microsoft_generated_data_3000[1:(3000 * 30), ]

window_size <- window_size * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

granularity <- c(100 / 32,  100 / 48)

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.05)
additional_setting <- list("cut_off_prob" = cut_off_prob, "window_type_for_reg" = window_type_for_reg)

bg_param_setting <- expand.grid("granularity" = granularity, state_num = state_num, "window_size" = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting,
                          data.frame(class = "MULTINOM", name = "Multinomial", train_policy = "fixed", train_size = 1990 * 30, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting$window_size_for_reg <- bg_param_setting$window_size
d <- run_sim(bg_param_setting, additional_setting, microsoft_generated_data_3000,
             list("max" = microsoft_generated_data_3000, "avg" = microsoft_generated_data_3000, "min" = microsoft_generated_data_3000, "sd" = microsoft_generated_data_3000, "median" = microsoft_generated_data_3000),
             start_point = 10 * 30 + 1,
             cores = parallel::detectCores(),
             write_type = c("charwise", "paramwise"),
             plot_type = "none",
             result_loc = "~/SimulationResult/StateNum/Multinom/")


