#!/usr/bin/Rscript
## Joshua Moller-Mara

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
ggsave("generated/ledger.png")

ledgerToDT <- function(command) {
    ledger.out <- system(command, intern = TRUE)
    if(length(ledger.out) == 0)
        return(0)
    dt <- data.table(read.csv(text = ledger.out, header = FALSE))
    setnames(dt, c("DateString", "Check", "Recipient",
                   "Account", "Currency", "Amount",
                   "Cleared", "Comment"))
    dt[,Date:=as.Date(DateString)]
    dt[,sum(Amount)]
}

bigtable <- data.frame(symbol = "", expression = "")

bigtable <- rbind(
    c("expenses", "ledger --effective -b \"this month\" -e tomorrow csv ^expenses"),
    c("expensesee", "ledger --effective -b \"this month\" -e tomorrow csv \"Eating out\""),
    c("expensesinc", "ledger --effective -b \"this month\" -e tomorrow csv ^expenses income"),
    c("expensesweek", "ledger --effective -b \"this week\" -e tomorrow csv ^expenses"),
    c("wallet", "ledger csv wallet"),
    c("amex", "ledger csv \"American Express\""),
    c("visa", "ledger csv \"Visa\""),
    c("checking", "ledger csv checking liabilities"))

sink("generated/finance-output.tex")

cat(paste0("\\def\\", bigtable[,1],
           "{",
           round(sapply(bigtable[,2], function(x)ledgerToDT(x)), digits = 2),
           "}\n"))

sink()





