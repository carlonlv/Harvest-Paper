library(DataCenterSim)
library(dplyr)

load("~/Documents/PDSF Dataset/microsoft_generated_data_3000.rda")
microsoft_generated_data_3000 <- microsoft_generated_data_3000[1:(3000 * 30), ]

## Finding best predictor using ARIMA, LM, Markov
window_size <- c(1, 10, 20, 30, 40, 50) * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

granularity <- 100 / 32

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)
additional_setting <- list("cut_off_prob" = cut_off_prob, "train_args" = list("order" = c(1,0,0)), "include_response_window_size" = TRUE, "window_type_for_reg" = window_type_for_reg)

for (i in window_size) {
  bg_param_setting <- expand.grid("window_size" = i, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting,
                            data.frame(class = "ARIMA", name = "AR1(max.avg.min.sd.median)", granularity = granularity, train_policy = "fixed", train_size = 2000 * 30, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  d <- run_sim(bg_param_setting, additional_setting, microsoft_generated_data_3000,
               microsoft_generated_data_3000,
               start_point = 1,
               cores = parallel::detectCores(),
               write_type = c("charwise", "paramwise"),
               plot_type = "none",
               result_loc = "~/Documents/SimulationResult/FindBestPredictor/AR1/")
}

