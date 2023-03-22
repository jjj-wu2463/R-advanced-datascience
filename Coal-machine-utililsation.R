#Deliverable: List with the following components-
# Character: machine name
# Vector:    (min, mean, max) Utilization for the month exc. unknown hours
# Logical:   has utilization ever fallen below 90% (TRUE/FALSE)
# Vector:    all hours where utilization is unknown (NA's)
# Dataframe: for this machine
# Plot:      for all machines



getwd()
setwd("C:\\Users\\Joan Wu\\Downloads")

util <- read.csv("P3-Machine-Utilization.csv")
head(util,12)
str(util)

#convert chr to factor
util$Timestamp <- factor(util$Timestamp)
util$Machine <- factor(util$Machine)
str(util)
summary(util)

#Derive utilization (1-Idle) for utilisation percentage
util$Utilization <- 1-util$Percent.Idle

#Handling Timestamp
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp,format="%d/%m/%Y %H:%M")
head(util,12)

summary(util)

#how to rearrange columns in a dataframe
util$Timestamp<-NULL #delete a column
util <- util[,c(4,1,2,3)] #rearrange columns
head(util,12)

#subset RL1
RL1 <- util[util$Machine=="RL1",]
RL1$Machine <- factor(RL1$Machine)
summary(RL1)

#Construct list
# Character: machine name
# Vector:    (min, mean, max) Utilization for the month exc. unknown hours
# Logical:   has utilization ever fallen below 90% (TRUE/FALSE)

util_stats_rl1 <- c(min(RL1$Utilization,na.rm=T),
                    mean(RL1$Utilization,na.rm=T),
                    max(RL1$Utilization,na.rm=T))

util_under_90_flag <- length(which(RL1$Utilization<0.90))>0

list_RL1 <- list("RL1",util_stats_rl1,util_under_90_flag)
list_RL1

#Naming a list
names(list_RL1) <- c("Machine","Stats","LowThreshold")
names(list_RL1)
rm(list_RL1)

#alternatively 
list_RL1 <- list(Machine="RL1",Stats=util_stats_rl1,LowThreshold=util_under_90_flag)

#Extract components from a list
#three ways:
##1. [] - will always return a list
##2. [[]] - will always return the actual object
##3. $ - same as [[]] but prettier 

list_RL1[1] #returns with the name (returns a list)
list_RL1[[1]] #returns a double (components in the list)
list_RL1$Machine

list_RL1[[2]]

#access the 3rd element of the vector (max utilization)
list_RL1$Stats[3]
list_RL1[[2]][3]

##adding components to a list
# Vector:    all hours where utilization is unknown (NA's)
list_RL1[6] <- "test" #in between components will show as NULL
list_RL1$Unknown_hours <- RL1[is.na(RL1$Utilization),"PosixTime"]
list_RL1


#removing a component, the index is shifted
list_RL1[5] <- NULL


#add another component
# Dataframe: for this machine
list_RL1$Data <- RL1
summary(list_RL1)

#subsetting a list
list_RL1[[4]][1]
list_RL1$Unknown_hours[1]
list_RL1[c(1,4)]
sublist <- list_RL1[c("Machine","Stats")]
sublist

#timeseries plot
library(ggplot2)


#facet grid to seperate components into different plots
p <- ggplot(data=util)
my_plot<-p + geom_line(aes(x=PosixTime,y=Utilization,
                  colour=Machine), size=1.2) +
  facet_grid(Machine~.) + 
  geom_hline(yintercept=0.90,
             colour="Gray", size=1,
             linetype=3)

#add to list
list_RL1$plot <- my_plot
list_RL1
















