## Joshua Moller-Mara
## Show the amount of reading per day

library(data.table)
library(ggplot2)

## TODO: Move this to ZPM directory.
reading <- data.table(read.csv("~/org/data/reading.csv"))
reading$Date <- as.Date(reading$Date, format = "%Y-%m-%d")
reading[, NumPages:=End-Start]
reading[, BookTrim := strtrim(Book, 20)]

reading[, Week:=format(reading$Date, "%Y-%W")]
reading[, Month:=format(reading$Date, "%Y-%m")]
reading[, list(startDate=min(Date), endDate=max(Date), totalPages=sum(NumPages)), by = Week]

(weekly.reading <- reading[Week==format(Sys.time(), "%Y-%W"),sum(NumPages)])
(monthly.reading <- reading[Month==format(Sys.time(), "%Y-%m"),sum(NumPages)])

## Number of pages for this week
sink("generated/reading-output.tex")
cat("\\def\\weeklyreading{", weekly.reading, "}\n")
cat("\\def\\monthlyreading{", weekly.reading, "}\n")
sink()
