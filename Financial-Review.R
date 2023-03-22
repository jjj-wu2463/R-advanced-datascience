#Deliverable:
# Scatter plot by industry showing revenue, expenses, profit
# Scatter plot that includes industry trends for expenses~revenue relationship
# Box plot showing growth by industry

getwd()
setwd("C:\\Users\\Joan Wu\\Downloads")


fin <- read.csv("P3-Future-500-The-Dataset.csv",stringsAsFactors = T)
head(fin)
tail(fin)
str(fin)
summary(fin)

#changing from non factor to factor
fin$ID<-factor(fin$ID)
fin$Inception<-factor(fin$Inception)

#Factor Variable Trap (FVT)

##Practice
#convert char into numeric
a<-c("12","13","14","12","12")
typeof(a)
b <- as.numeric(a)
typeof(b)

#factor into numeric

z<-factor(c("12","13","14","12","12"))
z
y <- as.numeric(z)
y
typeof(y)
x <- as.numeric(as.character(z))


#--------------------RESTART: DATA PREPARATION

#basic import: fin <- read.csv("P3-Future-500-The-Dataset.csv",stringsAsFactors = T)
#replace empty characters with NA since import step
#or replace a variable with NA eg:'na.strings = c("NY")'.
fin <- read.csv("P3-Future-500-The-Dataset.csv",stringsAsFactors = T,na.strings = c(""))
head(fin)
tail(fin)
str(fin)
summary(fin)

#changing from non factor to factor
fin$ID<-factor(fin$ID)
fin$Inception<-factor(fin$Inception)

#changing from factor to non factor --> FVT
#FVT Example

#fin$Profit <- factor(fin$Profit) 
str(fin)

#sub() and gsub() --> to replace
fin$Expenses <- gsub(" Dollars","",fin$Expenses)
fin$Expenses <- gsub(",","",fin$Expenses)
head(fin)

#escape sequence for $, as $ is specially used in R (also applicable to some other signs, LOK UP IN GOOGLE)
fin$Revenue <- gsub("\\$","",fin$Revenue)
fin$Revenue <- gsub(",","",fin$Revenue)
head(fin)

fin$Growth <- gsub("%","",fin$Growth)
str(fin)

#convert from char to numeric
fin$Revenue<-as.numeric(fin$Revenue)
fin$Expenses<-as.numeric(fin$Expenses)
fin$Growth<-as.numeric(fin$Growth)
summary(fin)

#dealing with missing data (NA)
##1. Predict with 100% accuracy (according to facts)
##2. Leave the record as it is 
##3. Remove the record entirely (remove the whole row)
##4. Replace with mean/median.
##5. Fill in by exploring correlations & similarities
##6. Introduce dummy variable "Missingness"

#NA - missing value indicator (logic value) -- other than 1:TRUE and 0:FALSE

head(fin,24)

#identify rows with missing data
fin[!complete.cases(fin),]

#identify specific row but will show NA
fin[fin$Revenue==9746272,]

#how to show only the specific row
# which(fin$Revenue==9746272):returns the row index with TRUE value
fin[which(fin$Revenue==9746272),]

head(fin)
fin[which(fin$Employees==45),]

#Filtering: using is.na() for missing data
#picking out all rows with values 'na' from a specific column
fin[is.na(fin$State),]

#Removing records with missing data
#eg. removing empty rows in "Industry"
fin_backup <- fin #set backup data
fin <- fin_backup
fin[!is.na(fin$Industry),]
fin <- fin[!is.na(fin$Industry),]

#Resetting the data frame index (the row index does not change when rows are removed)
fin
rownames(fin) <- 1:nrow(fin)
#alternatively
rownames(fin) <- NULL
fin

#replacing missing data with 100% certainty eg. city, state
fin[!complete.cases(fin),]
fin[is.na(fin$State)& fin$City=="New York",]
fin[is.na(fin$State)& fin$City=="New York","State"] <- "NY"

#check:
fin[c(11,377),]


fin[is.na(fin$State)& fin$City=="San Francisco",]
fin[is.na(fin$State)& fin$City=="San Francisco","State"] <- "CA"
#check:
fin[c(82,265),]

#replacing missing data with median imputation method
#Employees - Retail
med_emp_retail <- median(fin[fin$Industry=="Retail","Employees"],na.rm=TRUE)
fin[is.na(fin$Employees)&fin$Industry=="Retail","Employees"]<-med_emp_retail
fin[3,]
#Employees - Financial Services
med_emp_finserv <- median(fin[fin$Industry=="Financial Services","Employees"],na.rm=TRUE)
fin[is.na(fin$Employees)&fin$Industry=="Financial Services","Employees"]<-med_emp_retail
fin[330,]
#Growth
med_growth<- median(fin[fin$Industry=="Construction","Growth"],na.rm=TRUE)
mean(fin[fin$Industry=="Construction","Growth"],na.rm=TRUE)
fin[is.na(fin$Growth)&fin$Industry=="Construction","Growth"]<-med_growth
fin[8,]
#Revenue and Expenses
med_rev_const<- median(fin[fin$Industry=="Construction","Revenue"],na.rm=TRUE)
fin[is.na(fin$Revenue)&fin$Industry=="Construction","Revenue"] <- med_rev_const

#to not overwrite expenses with calculated profit 
med_exp_const<- median(fin[fin$Industry=="Construction","Expenses"]& is.na(fin$Profit),na.rm=TRUE)
fin[is.na(fin$Expenses)&fin$Industry=="Construction","Expenses"] <- med_exp_const
fin[c(8,42),]

#replace with deriving values method
#Revenue-Expenses=Profit
fin[!complete.cases(fin),]
fin[is.na(fin$Profit),]
fin[is.na(fin$Profit),"Profit"]<-fin[is.na(fin$Profit),"Revenue"]-fin[is.na(fin$Profit),"Expenses"]
fin[c(8,42),]

#Expenses=Revenue-Profit
fin[is.na(fin$Expenses),"Expenses"] <-fin[is.na(fin$Expenses),"Revenue"]-fin[is.na(fin$Expenses),"Profit"]
fin[15,]


##-----------------------DATA VISUALISATION
library(ggplot2)
p <- ggplot(data=fin)

#scatter plot
p + geom_point(aes(x=Revenue,y=Expenses,
                   colour=Industry, size = Profit))

#new plot with preset aesthetics
d <- ggplot(data=fin,aes(x=Revenue, y= Expenses,
                         colour=Industry))

d + geom_point() +
  geom_smooth(fill=NA,linewidth=1)

#box plot
f <- ggplot(data=fin,aes(x=Industry, y=Growth,
                         colour=Industry))
f + geom_boxplot(size=1)

#extra
f + geom_jitter()+
  geom_boxplot(size=1,alpha=0.5,outlier.colour=NA)