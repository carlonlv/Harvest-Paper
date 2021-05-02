library("DataCenterSim")
library("dplyr")

load("~/microsoft_10000.rda")
load("~/SimulationResult/datasets/microsoft_traces_labels.rda")

result_path <- "~/SimulationResult/datasets/"

microsoft_max_10000 <- microsoft_max_10000[, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]
microsoft_avg_10000 <- microsoft_avg_10000[, c(1:3019)[-c(286,290,328,380,387,398,399,704,706,718,720,738,813,1571,1637,1638,2021,3012,3018)]]

tp_microsoft_max_10000 <- do.call(cbind, lapply(1:ncol(microsoft_max_10000), function(i){
  DataCenterSim:::convert_frequency_dataset(microsoft_max_10000[,i], 12, response = "max")
}))
colnames(tp_microsoft_max_10000) <- colnames(microsoft_max_10000)
tp_microsoft_avg_10000 <-  do.call(cbind, lapply(1:ncol(microsoft_avg_10000), function(i){
  DataCenterSim:::convert_frequency_dataset(microsoft_avg_10000[,i], 12, response = "avg")
}))
colnames(tp_microsoft_avg_10000) <- colnames(microsoft_avg_10000)


asd <- c("Delay-insensitive", "Interactive", "Unkown", "Pooled")

## Delay-insensitive
for (i in asd) {
  if (i == "Pooled") {
    dd <- microsoft_traces_labels$ts_num
  } else {
    dd <- microsoft_traces_labels$ts_num[microsoft_traces_labels$label == i]
  }

  temp_microsoft_max_10000 <- tp_microsoft_max_10000[,which(as.numeric(colnames(microsoft_max_10000)) %in% dd)]
  temp_microsoft_avg_10000 <- tp_microsoft_avg_10000[,which(as.numeric(colnames(microsoft_avg_10000)) %in% dd)]

  ## Max-to-Max
  plot_heatmap_correlations(dataset1 = temp_microsoft_max_10000,
                            dataset2 = NULL,
                            window_size1 = 1:25,
                            window_size2 = 1:25,
                            response1 = "max",
                            response2 = NULL,
                            corr_method = "pearson",
                            cores = parallel::detectCores(),
                            name = paste0("Max-Max ", "(", i, ") in 1hr"),
                            result_path)

  ## Avg-to-Avg
  plot_heatmap_correlations(dataset1 = temp_microsoft_avg_10000,
                            dataset2 = NULL,
                            window_size1 = 1:25,
                            window_size2 = 1:25,
                            response1 = "avg",
                            response2 = NULL,
                            corr_method = "pearson",
                            cores = parallel::detectCores(),
                            name = paste0("Avg-Avg ", "(", i, ") in 1hr"),
                            result_path)

  ## Avg-to-Max
  plot_heatmap_correlations(dataset1 = temp_microsoft_avg_10000,
                            dataset2 = temp_microsoft_max_10000,
                            window_size1 = 1:25,
                            window_size2 = 1:25,
                            response1 = "avg",
                            response2 = "max",
                            corr_method = "pearson",
                            cores = parallel::detectCores(),
                            name = paste0("Avg-Max ", "(", i, ") in 1hr"),
                            result_path)
}

