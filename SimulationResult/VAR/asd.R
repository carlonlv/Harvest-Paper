library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- 100 / 32
cut_off_prob <- c(0.001, 0.003, 0.01, 0.03, 0.05)
p <- c(1, 2, 3, 4)
window_size <- c(30, 40, 50)
additional_setting <- list("cut_off_prob" = cut_off_prob, "include_response_window_size" = TRUE, "window_type_for_reg" = "avg")
bg_param_setting <- expand.grid(p = p, window_size = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "VAR", granularity = granularity, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
bg_param_setting[, "name"] <- paste0("VAR(", bg_param_setting$p, ")")

d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, microsoft_avg_10000, cores = parallel::detectCores(), write_type = c("charwise", "paramwise"), plot_type = "none", result_loc = "~/SimulationResult/VAR/p/")
