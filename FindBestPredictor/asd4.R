library(DataCenterSim)
library(dplyr)

load("~/microsoft_generated_data_3000.rda")
microsoft_generated_data_3000 <- microsoft_generated_data_3000[1:(3000 * 30), ]

granularity <- 100 / 32
cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)

p <- c(1, 2)
window_size <- c(1, 5, 10, 15, 20, 25) * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

bg_param_setting <- expand.grid(p = p, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "VAR", granularity = granularity, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting$window_size_for_xreg <- bg_param_setting$window_size
bg_param_setting[, "name"] <- paste0("VAR(", bg_param_setting$p, ")")

d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/VAR/p/")


additional_setting <- list("cut_off_prob" = cut_off_prob, "window_type_for_reg" = window_type_for_reg)

bg_param_setting <- cbind(bg_param_setting,
                          data.frame(class = "ARIMA", name = "AR1(max,avg,min,sd,median)", granularity = granularity, train_policy = "fixed", train_size = 1990 * 30, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting$window_size_for_reg <- bg_param_setting$window_size
d <- run_sim(bg_param_setting, additional_setting, microsoft_generated_data_3000,
             list("max" = microsoft_generated_data_3000, "avg" = microsoft_generated_data_3000, "min" = microsoft_generated_data_3000, "sd" = microsoft_generated_data_3000, "median" = microsoft_generated_data_3000),
             start_point = 10 * 30 + 1,
             cores = parallel::detectCores(),
             write_type = c("charwise", "paramwise"),
             plot_type = "none",
             result_loc = "~/SimulationResult/FindBestPredictor/VAR1/")
