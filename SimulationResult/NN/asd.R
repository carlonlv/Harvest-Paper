library(DataCenterSim)
library(dplyr)

load("~/Documents/PDSF Dataset/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

cut_off_prob <- c(0.001, 0.003, 0.01, 0.03, 0.05)
p <- c(1, 2, 3, NA_real_)
window_size <- c(1, 5, 10, 15, 20, 25, 30, 40, 50)
granularity <- 100 / 32

additional_setting <- list("cut_off_prob" = cut_off_prob)
bg_param_setting <- expand.grid(p = p, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "NN", P = 0, granularity = granularity, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting[, "name"] <- ifelse(is.na(bg_param_setting$p), "NN(auto)", paste0("NN(", bg_param_setting$p, ")"))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = 1, write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/NN/p/")
