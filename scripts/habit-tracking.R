## Joshua Moller-Mara
## Habit Tracking
options(stringsAsFactors = FALSE)

## State: Last Scheduled
## Last Completed
## # Completed

## Habit, Last Date, # Complete, # Needed, Next Date

## Number of boxes per day?
## Number of boxes needed per week?

## Checkboxes vs numeric?
## I think numeric stuff will just be reading. So just checkboxes?

dt[,sum(complete) > needed, by = c("habit", "scheduled")]


##############################

## Probably the most important part to figure out will be scheduling?

scheduler <- function(thedate) {
    print(format (thedate, "The weekday is %a"))
    print(format (thedate, "The week number is %W"))
}


scheduler(Sys.Date())

ear.training <- function(thedate, habits) {
    if(format (thedate, "%a") %in% c("Mon"))
        data.frame(thedate, "Ear Training", 1, NA, format(thedate, "%Y-W%W"), "blah")
}

BT <- function(thedate, habits) {
    if(format (thedate, "%a") %in% c("Mon", "Tue"))
        data.frame(thedate, "BT", 1, NA, format(thedate, "%Y-W%W"), "blah")
}

(x <- as.data.frame(do.call(rbind, lapply(1:6, function(x) ear.training(Sys.Date())))))

habits <- list(ear.training, BT)

(x <- as.data.frame(do.call(rbind, lapply(habits, function(x) x(Sys.Date(), dt)))))

as.data.frame(rbind(ear.training(Sys.Date(), ha)))

habits.df <- read.csv("tracking/habits.csv")
habits.df$Date <- as.Date(habits.df[,1])
dt <- data.table(habits.df)

dt[Habit=="Ear Training",]
dt[,Habit]

ear.training(Sys.Date())

Sys.Date()

## Date
## Habit
## Boxnum
## Value
## Block
## Display


