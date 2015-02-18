#!/usr/bin/Rscript
## Joshua Moller-Mara
## Read in org-agenda CSV.

library(data.table)
library(stringr)

blah <- read.csv("org-agenda.csv", header = FALSE, stringsAsFactors = FALSE)

names(blah) <- c("category", "heading", "type", "todo", "tags", "date", "time", "extra", "priority.l", "priority.n", "agenda.day")

blah$date <- as.Date(blah$date, format = "%Y-%m-%d")
blah$agenda.day <- as.Date(blah$agenda.day, format = "%Y-%m-%d")
str_match(blah$time, "\\((.*?) :: (0\\.[0-9]+)\\)")
thematches <- str_match(blah$time, "([0-9]+:[0-9]+)[.-]+([0-9]+:[0-9]+)?")
blah$startTime <- thematches[,2]
blah$startTime <- ifelse(is.na(blah$startTime), "", blah$startTime)
blah$endTime <- thematches[,3]
blah$endTime <- ifelse(is.na(blah$endTime), "", blah$endTime)

dt <- data.table(blah)

dt[type!="",]

dt[,time]

## Format
## \reminder{2013}{07}{28}{Event 1}{Event 1}{}{}{}

sink("testdates.tex")
cat(dt[type!="", paste0("\\reminder{", format(date, "%Y"), "}{",
                        format(date, "%m"), "}{",
                        format(date, "%d"), "}{",
                        substr(heading, 0, 5), "}{",
                        heading, "}{}{",
                        startTime, "}{",
                        endTime, "}\n")])
sink()

sink("overdue-dates.tex")
cat(dt[type=="past-scheduled", paste0("", format(date, "%Y/%m/%d - "),
                        heading, "\\\\\n")])
sink()
