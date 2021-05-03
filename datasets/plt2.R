library("DataCenterSim")
library("dplyr")

load("~/SimulationResult/datasets/google_production_cpu.rda")
load("~/SimulationResult/datasets/google_production_memory.rda")

result_path <- "~/SimulationResult/datasets/"

contains_NA <- sapply(1:ncol(google_max_cpu), function(i) {
  any(is.na(google_max_cpu[,i]) | is.na(google_avg_cpu[,i]) | is.na(google_max_memory[,i]) | is.na(google_avg_memory[,i]))
})

google_max_cpu <- google_max_cpu[,!contains_NA][,1:3000]
google_avg_cpu <- google_avg_cpu[,!contains_NA][,1:3000]
google_max_memory <- google_max_memory[,!contains_NA][,1:3000]
google_avg_memory <- google_avg_memory[,!contains_NA][,1:3000]

tp_google_max_cpu <- do.call(cbind, lapply(1:ncol(google_max_cpu), function(i){
  DataCenterSim:::convert_frequency_dataset(google_max_cpu[,i], 1, response = "max")
}))
colnames(tp_google_max_cpu) <- colnames(google_max_cpu)

tp_google_avg_cpu <-  do.call(cbind, lapply(1:ncol(google_avg_cpu), function(i){
  DataCenterSim:::convert_frequency_dataset(google_avg_cpu[,i], 1, response = "avg")
}))
colnames(tp_google_avg_cpu) <- colnames(google_avg_cpu)

tp_google_max_memory <- do.call(cbind, lapply(1:ncol(google_max_memory), function(i){
  DataCenterSim:::convert_frequency_dataset(google_max_memory[,i], 1, response = "max")
}))
colnames(tp_google_max_memory) <- colnames(google_max_memory)

tp_google_avg_memory <- do.call(cbind, lapply(1:ncol(google_avg_memory), function(i){
  DataCenterSim:::convert_frequency_dataset(google_avg_memory[,i], 1, response = "max")
}))
colnames(tp_google_avg_memory) <- colnames(google_avg_memory)

## Max-to-Max
plot_heatmap_correlations(dataset1 = tp_google_max_cpu,
                          dataset2 = tp_google_max_memory,
                          window_size1 = 1:25,
                          window_size2 = 1:25,
                          response1 = "max",
                          response2 = "max",
                          corr_method = "pearson",
                          cores = parallel::detectCores(),
                          name = paste0("Google (CPU-Memory) Max-Max ", "in 5min"),
                          result_path)

## Avg-to-Avg
plot_heatmap_correlations(dataset1 = tp_google_avg_cpu,
                          dataset2 = tp_google_avg_memory,
                          window_size1 = 1:25,
                          window_size2 = 1:25,
                          response1 = "avg",
                          response2 = "avg",
                          corr_method = "pearson",
                          cores = parallel::detectCores(),
                          name = paste0("Google (CPU-Memory) Avg-Avg ", "in 5min"),
                          result_path)

## Avg-to-Max
plot_heatmap_correlations(dataset1 = tp_google_avg_cpu,
                          dataset2 = tp_google_max_memory,
                          window_size1 = 1:25,
                          window_size2 = 1:25,
                          response1 = "avg",
                          response2 = "max",
                          corr_method = "pearson",
                          cores = parallel::detectCores(),
                          name = paste0("Google (CPU-Memory) Avg-Max ", "in 5min"),
                          result_path)

## Max-to-Avg
plot_heatmap_correlations(dataset1 = tp_google_max_cpu,
                          dataset2 = tp_google_avg_memory,
                          window_size1 = 1:25,
                          window_size2 = 1:25,
                          response1 = "max",
                          response2 = "avg",
                          corr_method = "pearson",
                          cores = parallel::detectCores(),
                          name = paste0("Google (CPU-Memory) Max-Avg ", "in 5min"),
                          result_path)
