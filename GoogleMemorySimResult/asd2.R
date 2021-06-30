library(DataCenterSim)
library(dplyr)

load("~/google_generated_data_memory.rda")

google_generated_data_memory <- google_generated_data_memory[,1:3000]

window_size <- c(1, 5, 10, 15, 20, 25, 30, 40, 50) * 30

window_type_for_reg <- c("max", "avg", "min", "sd", "median")

granularity <- 0

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)
additional_setting <- list("cut_off_prob" = cut_off_prob, "include_response_window_size" = TRUE, "window_type_for_reg" = window_type_for_reg)

bg_param_setting <- expand.grid("granularity" = granularity, "window_size" = window_size, stringsAsFactors = FALSE)
bg_param_setting <- cbind(bg_param_setting,
                          data.frame(class = "MULTINOM", name = "Multinomial", train_policy = "fixed", train_size = 2000 * 30, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
d <- run_sim(bg_param_setting,
             additional_setting,
             google_generated_data_memory,
             google_generated_data_memory,
             start_point = 1,
             cores = parallel::detectCores(),
             write_type = c("charwise", "paramwise"),
             plot_type = "none",
             result_loc = "~/SimulationResult/GoogleMemorySimResult/Multinom/")


