library(DataCenterSim)
library(dplyr)
library(ggplot2)


load("~/Documents/GitHub/SimulationResult/datasets/google_production_cpu.rda")
load("~/Documents/GitHub/SimulationResult/datasets/google_production_memory.rda")

contains_NA <- sapply(1:ncol(google_max_cpu), function(i) {
  any(is.na(google_max_cpu[,i]) | is.na(google_avg_cpu[,i]) | is.na(google_max_memory[,i]) | is.na(google_avg_memory[,i]))
})

google_max_cpu <- google_max_cpu[,!contains_NA][,1:3000]
google_avg_cpu <- google_avg_cpu[,!contains_NA][,1:3000]
google_max_memory <- google_max_memory[,!contains_NA][,1:3000]
google_avg_memory <- google_avg_memory[,!contains_NA][,1:3000]


## SCALING
fac <- sapply(1:ncol(google_max_cpu), function(i) {
  max_dat <- max(google_max_cpu[,i])
  ten_power <- which((max_dat * 10^(1:100) <= 100) & (max_dat * 10^(1:100) > 10))[1]
  ten_power
})

google_max_cpu <- do.call(cbind, lapply(1:ncol(google_max_cpu), function(i){
  (10 ^ (fac[i])) * google_max_cpu[,i]
}))

google_avg_cpu <- do.call(cbind, lapply(1:ncol(google_avg_cpu), function(i){
  (10 ^ (fac[i])) * google_avg_cpu[,i]
}))

fac <- sapply(1:ncol(google_max_memory), function(i) {
  max_dat <- max(google_max_memory[,i])
  ten_power <- which((max_dat * 10^(1:100) <= 100) & (max_dat * 10^(1:100) > 10))[1]
  ten_power
})

google_max_memory <- do.call(cbind, lapply(1:ncol(google_max_memory), function(i) {
  (10 ^ (fac[i])) * google_max_memory[,i]
}))

google_avg_memory <- do.call(cbind, lapply(1:ncol(google_avg_memory), function(i) {
  (10 ^ (fac[i])) * google_avg_memory[,i]
}))
