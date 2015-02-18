#!/usr/bin/Rscript
## Joshua Moller-Mara
## Read in org-agenda CSV.

library(data.table)
library(stringr)
library(ggplot2)

ledger.out <- system("ledger --effective -b \"this month\" -e tomorrow csv ^expenses income",
                     intern = TRUE)

dt <- data.table(read.csv(text = ledger.out, header = FALSE))

setnames(dt, c("DateString", "Check", "Recipient",
               "Account", "Currency", "Amount",
               "Cleared", "Comment"))

dt[,Date:=as.Date(DateString)]
blah <- dt[order(Date)][,list(Date, cumulative = -cumsum(Amount))]

ggplot(blah, aes(x = Date, y = cumulative)) + geom_line()

ledgerToDT <- function(command) {
    ledger.out <- system(command, intern = TRUE)
    dt <- data.table(read.csv(text = ledger.out, header = FALSE))
    setnames(dt, c("DateString", "Check", "Recipient",
                   "Account", "Currency", "Amount",
                   "Cleared", "Comment"))
    dt[,Date:=as.Date(DateString)]
    dt
}

expenses <- ledgerToDT("ledger --effective -b \"this month\" -e tomorrow csv ^expenses income")[,-sum(Amount)]
wallet <- ledgerToDT("ledger csv wallet")[,sum(Amount)]
amex <- ledgerToDT("ledger csv \"American Express\"")[,sum(Amount)]
visa <- ledgerToDT("ledger csv \"Visa\"")[,sum(Amount)]
checking <- ledgerToDT("ledger csv checking liabilities")[,sum(Amount)]


sink("finance-output.tex")
cat(paste0("\\def\\", c("expenses", "wallet", "amex", "visa", "checking"),
           "{",
           round(c(expenses, wallet, amex, visa, checking), digits = 2),
           "}\n"))
sink()
