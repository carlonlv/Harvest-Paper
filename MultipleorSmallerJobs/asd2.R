library(DataCenterSim)
library(dplyr)

load("~/Documents/PDSF Dataset/microsoft_generated_data_3000.rda")
microsoft_generated_data_3000 <- microsoft_generated_data_3000[1:(3000 * 30), ]

window_size <- c(1, 5, 10, 15, 20, 25) * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

## 8, 16, 32, 64 Cores
granularity <- c(100 / 32)

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)

schedule_setting <- c("max_size", "2_jobs", "4_jobs", "1_cores", "2_cores")

additional_setting <- list("cut_off_prob" = cut_off_prob, "reg_mapping_rule" = "one_to_many", "window_type_for_reg" = window_type_for_reg)

bg_param_setting <- expand.grid("granularity" = granularity, "schedule_setting" = schedule_setting, "window_size" = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting,
                          data.frame(class = "MULTINOM", name = "Multinomial", train_policy = "fixed", train_size = 2000 * 30, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting$window_size_for_reg <- bg_param_setting$window_size
d <- run_sim(bg_param_setting, additional_setting, microsoft_generated_data_3000,
             list("max" = microsoft_generated_data_3000, "avg" = microsoft_generated_data_3000, "min" = microsoft_generated_data_3000, "sd" = microsoft_generated_data_3000, "median" = microsoft_generated_data_3000),
             cores = parallel::detectCores(),
             write_type = c("charwise", "paramwise"),
             plot_type = "none",
             result_loc = "~/SimulationResult/SmartHarvestComparison/Multinom/")


