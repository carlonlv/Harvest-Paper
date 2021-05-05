library(DataCenterSim)
library(dplyr)

load("~/microsoft_generated_data_3000.rda")
microsoft_generated_data_3000 <- microsoft_generated_data_3000[1:(3000 * 30), ]

window_size <- c(1, 5, 10, 15, 20, 25)

granularity <- c(100 / 32)

cut_off_prob <- c(0.0001, 0.0003, 0.0005, 0.001, 0.003, 0.005, 0.01, 0.03, 0.05)

schedule_setting <- c("max_size", "2_jobs", "4_jobs", "1_cores", "2_cores")

additional_setting <- list("cut_off_prob" = cut_off_prob, "window_type_for_reg" =  c("max", "avg", "min", "sd", "median"), "window_size_for_reg" = 1)

temp_x <- do.call(cbind, parallel::mclapply(1:ncol(microsoft_generated_data_3000), function(k) {
  convert_frequency_dataset(microsoft_generated_data_3000[,k], 30, "max")
}, mc.cores = parallel::detectCores()))
colnames(temp_x) <- colnames(microsoft_generated_data_3000)
rownames(temp_x) <- 1:nrow(temp_x)

for (i in window_size) {
  bg_param_setting <- expand.grid("granularity" = granularity, "schedule_setting" = schedule_setting, "window_size" = i, stringsAsFactors = FALSE)
  bg_param_setting <- cbind(bg_param_setting,
                            data.frame(class = "MULTINOM", name = "Multinomial(max.avg.min.sd.median)", train_policy = "fixed", train_size = 2000, update_freq = 3, react_speed = "1,2", extrap_step = 1, stringsAsFactors = FALSE))
  temp_xreg <- lapply(additional_setting[["window_type_for_reg"]], function(j) {
    asd <- do.call(cbind, parallel::mclapply(1:ncol(microsoft_generated_data_3000), function(k) {
      convert_frequency_dataset(microsoft_generated_data_3000[,k], 30 * i, j)
    }, mc.cores = parallel::detectCores))
    colnames(asd) <- colnames(temp_x)
    rownames(asd) <- rownames(temp_x)
    return(asd)
  })

  d <- run_sim(bg_param_setting, additional_setting, temp_x,
               temp_xreg,
               cores = parallel::detectCores(),
               write_type = c("charwise", "paramwise"),
               plot_type = "none",
               result_loc = "~/SimulationResult/MultipleorSmallerJobs/Multinomal")
}


