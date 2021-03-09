library(DataCenterSim)
library(dplyr)
library("DataCenterSim")
library("dplyr")

load("~/microsoft_generated_data_2000.rda")
microsoft_generated_data_2000 <- microsoft_generated_data_2000[1:(3000 * 30),]

window_size <- c(1, 5, 10, 15, 20, 25) * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

## 8, 16, 32, 64 Cores
granularity <- c(100 / 8, 100 / 16, 100 / 32, 100 / 64)

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)
additional_setting <- list("cut_off_prob" = cut_off_prob)

bg_param_setting <- data.frame(class = "MULTINOM", name = "Multinomial", window_size = window_size, window_size_for_reg = window_size_for_reg, granularity = 0, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
d <- run_sim(bg_param_setting, additional_setting, microsoft_generated_data_2000, list("avg" = microsoft_generated_data_2000, "min"), cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/FindBestPredictor/Markov/")


