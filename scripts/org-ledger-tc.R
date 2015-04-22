#!/usr/bin/Rscript
## Joshua Moller-Mara

library(data.table)
library(stringr)
library(ggplot2)
library(scales)

ledger.out <- system("org2tc ~/org/neuroecon.org | ledger -f - -b \"this week\" csv",
                     intern = TRUE)

dt <- data.table(read.csv(text = ledger.out, header = FALSE))

setnames(dt, c("DateString", "Check", "Recipient",
               "Account", "Currency", "Amount",
               "Cleared", "Comment"))

dt[,Date:=as.Date(DateString)]
blah <- dt[order(Date)][,list(Date, Hours = cumsum(Amount)/(60*60))]

formatSeconds <- function(numsecs) {
  now <- Sys.time()
  dt <- difftime(now + numsecs, now, units="secs")
  format(.POSIXct(dt,tz="GMT"), "%H:%M:%S")
}

dt[,formatSeconds(sum(Amount))]

ggplot(blah, aes(x = Date, y = Hours)) + geom_line() + scale_x_date(labels = date_format("%m/%d %a"), breaks = "1 day")
ggsave("generated/neuroecon.png")
