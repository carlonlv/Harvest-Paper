library(DataCenterSim)
library(dplyr)

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

granularity <- c(100 / 32)
## add 100 / 64

schedule_setting <- c("2_cores")
window_size <- c(1)
## add 1

cut_off_prob <- c(0.0001, 0.0005, 0.001, 0.005, 0.01, 0.02, 0.03, 0.05)

additional_setting <- list("cut_off_prob" = cut_off_prob)

bg_param_setting <- expand.grid(granularity = granularity, window_size = window_size, schedule_setting = schedule_setting, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting, data.frame(class = "ARIMA", name = "AR1", extrap_step = 1, train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting, additional_setting, microsoft_max_10000, NULL, cores = parallel::detectCores(), write_type = c("paramwise", "charwise"), plot_type = "none", result_loc = "~/MultipleorSmallerJobs/")
