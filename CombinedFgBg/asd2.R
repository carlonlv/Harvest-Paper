library(DataCenterSim)

load("~/google_2019_data.rda")

load("~/microsoft_10000.rda")

microsoft_max_10000 <- microsoft_max_10000[1:3000, c(1:2016)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638)]]
microsoft_avg_10000 <- microsoft_avg_10000[1:3000, c(1:2016)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638)]]

load("~/microsoft_generated_data_2000.rda")
microsoft_generated_data_2000 <- microsoft_generated_data_2000[1:(3000 * 30),]

bins <- c(0, 1, 3, 5, 7, 11, 15, 19, 29, 39, 42, 74, 105)

sim_length <- 106

heart_beats_percent <- 0.4

constraint_prob <- c(0.99)

machines_full_indicator <- 100

sim_setting_list <- list(#"Autopilot" = data.frame(class = "AUTOPILOT", window_size = 30, train_size = 2000, update_freq = 1, train_policy = "fixed", half_life = 16, cut_off_weight = 0.01, stringsAsFactors = FALSE),
  "AR1" = data.frame(class = "ARIMA", window_size = 1, train_size = 2000, update_freq = 1, train_policy = "fixed", stringsAsFactors = FALSE))
  #"ARI11" = data.frame(class = "ARIMA", window_size = 1, train_size = 2000, update_freq = 1, train_policy = "fixed", stringsAsFactors = FALSE),
  #"AR1X" = data.frame(class = "ARIMA", window_size = 1, train_size = 2000, update_freq = 1, train_policy = "fixed", stringsAsFactors = FALSE))

#sim_setting_list[["ARI11"]]$train_args <- list(order = c(1,1,0))

for (i in names(sim_setting_list)) {
  print(paste("Model name", i))

  set.seed(10)

  param_setting_sim <- sim_setting_list[[i]]
  param_setting_pred <- data.frame(name = "ANOVATREE", train_size = 20000, stringsAsFactors = FALSE)

  if (grepl("X", i)) {
    dd <- run_sim_pred(paste0("~/foreground_result", i, ".rda"),
                       paste0("~/background_result", "ANOVATREE", ".rda"),
                       param_setting_sim,
                       list("window_type_for_reg" = "avg"),
                       param_setting_pred,
                       list(),
                       microsoft_max_10000,
                       microsoft_avg_10000,
                       google_2019_data[, 6],
                       google_2019_data[,1:5],
                       sim_length,
                       constraint_prob,
                       machines_full_indicator,
                       heart_beats_percent,
                       bins,
                       cores = parallel::detectCores(),
                       write_type = "summary",
                       result_loc = "~/Documents/CombinedFgBg/FgModels/")
  } else if (i == "Autopilot") {
    dd <- run_sim_pred(paste0("~/foreground_result", i, ".rda"),
                       paste0("~/background_result", "ANOVATREE", ".rda"),
                       param_setting_sim,
                       list(),
                       param_setting_pred,
                       list(),
                       microsoft_generated_data_2000,
                       NULL,
                       google_2019_data[, 6],
                       google_2019_data[,1:5],
                       sim_length,
                       constraint_prob,
                       machines_full_indicator,
                       heart_beats_percent,
                       bins,
                       cores = parallel::detectCores(),
                       write_type = "summary",
                       result_loc = "~/Documents/CombinedFgBg/FgModels/")
  } else {
    dd <- run_sim_pred(paste0("~/foreground_result", i, ".rda"),
                       paste0("~/background_result", "ANOVATREE", ".rda"),
                       param_setting_sim,
                       list(),
                       param_setting_pred,
                       list(),
                       microsoft_max_10000,
                       NULL,
                       google_2019_data[, 6],
                       google_2019_data[,1:5],
                       sim_length,
                       constraint_prob,
                       machines_full_indicator,
                       heart_beats_percent,
                       bins,
                       cores = 1,
                       write_type = "summary",
                       result_loc = "~/Documents/CombinedFgBg/FgModels/")
  }
}
