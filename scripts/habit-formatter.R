## Joshua Moller-Mara
options(stringsAsFactors = FALSE)
library(data.table)

habits <- read.csv("tracking/habits.csv")
habits$Date <- as.Date(habits[,1])
dt <- data.table(habits)
