library(DataCenterSim)
library(dplyr)

library(nnet)

load("~/Documents/PDSF Dataset/microsoft_traces_labels.rda")

path = "~/Documents/GitHub/SimulationResult/AdHocAnalysis/"

result_files_prediction_statistics <- list.files(path, pattern = "Paramwise Prediction Statistics", full.names = TRUE, recursive = TRUE)
result_files_prediction_quantiles <- list.files(path, pattern = "Paramwise Simulation", full.names = TRUE, recursive = TRUE)

prediction_statistics <- read.csv(result_files_prediction_statistics, row.names = 1)
prediction_quantiles <- read.csv(result_files_prediction_quantiles, row.names = 1)

quant <- unique(prediction_quantiles$quantile)
classfied_traces <- label_performance_trace(prediction_quantiles, prediction_statistics, 1 - 0.95)

classfied_traces$predict_info_statistics <- classfied_traces$predict_info_statistics[, -which(colnames(classfied_traces$predict_info_statistics) == "trace_name")]

summarise_statistics.0.95 <-
  dplyr::group_by(classfied_traces$predict_info_statistics, label.0.95) %>%
  summarise_all(mean)

table(classfied_traces$predict_info_statistics$label.0.95)

prediction_statistics <- read.csv(result_files_prediction_statistics, row.names = 1)
prediction_quantiles <- read.csv(result_files_prediction_quantiles, row.names = 1)

quant <- unique(prediction_quantiles$quantile)
classfied_traces <- label_performance_trace(prediction_quantiles, prediction_statistics, 1 - 0.99)

summarise_statistics.0.99 <-
  dplyr::group_by(classfied_traces$predict_info_statistics, label.0.99) %>%
  summarise_all(mean)


#prcomp(classfied_traces$predict_info_statistics[1:24])



multinomial_reg <- nnet::multinom(as.formula(paste("label.0.95 ~ ", paste(colnames(classfied_traces$predict_info_statistics)[1:24], collapse = " + "))), data = classfied_traces$predict_info_statistics)


View(coef(multinomial_reg))
