library(DataCenterSim)
library(dplyr)

load("~/Documents/PDSF Dataset/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 64)

window_size <- c(10, 30, 40, 50)

ddd <- expand.grid(granularity = granularity, window_size = window_size, stringsAsFactors = FALSE)
for (i in 1:nrow(ddd)) {
  bg_param_setting <- data.frame(class = "ARIMA", name = "AR1", window_size = 1, granularity = ddd[i, "granularity"], extrap_step = 1, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE)
  pre_compute_models_foreground(paste0("FPR_AR1_", ddd[i, "window_size"], "_", ddd[i, "granularity"], ".rda"), param_setting_sim = bg_param_setting, additional_param_sim = list(), foreground_x = microsoft_max_10000, foreground_xreg = NULL, sim_length = 1000, bins = ddd[i, "window_size"], cores = 1)
}

