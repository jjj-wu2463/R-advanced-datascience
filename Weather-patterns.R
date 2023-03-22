getwd()
setwd("C:\\Users\\Joan Wu\\Desktop\\Udemy Courses\\R_intermediate\\Weather Data")

#takes first column as row names
Chicago <- read.csv("Chicago-F.csv",row.names = 1)
Houston <- read.csv("Houston-F.csv",row.names = 1)
NewYork <- read.csv("NewYork-F.csv",row.names = 1)
SanFranc <- read.csv("SanFrancisco-F.csv",row.names = 1)

#Check
Chicago
Houston
NewYork
SanFranc

is.data.frame(Chicago)

#convert to matrix
Chicago <- as.matrix(Chicago)
Houston <- as.matrix(Houston)
NewYork <- as.matrix(NewYork)
SanFranc <- as.matrix(SanFranc)

#check:
is.matrix(Chicago)

#put into a list
Weather <- list(Chicago=Chicago, Houston=Houston, NewYork=NewYork, SanFranc=SanFranc)
Weather

#apply()
apply(Chicago,1,mean)
apply(Chicago,1,max)
apply(Chicago,1,min)

#Compare:
apply(Chicago,1,mean)
apply(Houston,1,mean)
apply(NewYork,1,mean)
apply(SanFranc,1,mean)
                       #<<< (nearly) Deliverable 1: but there is a faster way

#Recreate apply function using loops
Chicago
#find the mean for every row
#1. through loops
output <- NULL #prepare empty vector for results
for(i in 1:nrow(Chicago)){
  output[i]<-mean(Chicago[i,])
}
names(output) <- rownames(Chicago)
output
#2. apply
apply(Chicago,1,mean)


#using lapply() : returns a list as the output
#Example 1
mynewlist <-lapply(Weather, t)

#Example 2
Chicago
rbind(Chicago, NewRow=1:12)
lapply(Weather,rbind,NewRow=1:12)

#Example 3
lapply(Weather,rowMeans)
                   #<<< (nearly) Deliverable 1: even better, but will improve further!!

#Combining lapply with []
Weather
#extracting the first component of every matrix in the list 'Weather'
lapply(Weather,"[",1,1)
lapply(Weather,"[",1,) #extract first row of every matrix
lapply(Weather, "[", ,3) #extract column "march" for every matrix, aka 3rd column


#adding your own function
lapply(Weather, rowMeans)
lapply(Weather, function(x) x[1,])
lapply(Weather, function(x) x[5,])
lapply(Weather, function(x) x[,12])

lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))
                         #<<Deliverable 2 temp fluctuation, BUT WILL IMPROVE#

#sapply(): similar to lapply but return the output as a vector/matrix when possible
#AvgHigh_F for July
lapply(Weather,"[",1,7)
sapply(Weather,"[",1,7)
#AvgHigh_F for last quarter
lapply(Weather,"[",1,c(10,11,12))
sapply(Weather,"[",1,c(10,11,12))
#another example
round(sapply(Weather,rowMeans),2) #>>Deliverable 1 : READY TO GO!!

#another example:
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2)) #>> Deliverable 2: READY TO GO!!


#Nesting apply() functions
#apply across whole list (find the maximum for each row)
lapply(Weather,apply, 1 ,max)
lapply(Weather, function(x) apply(x,1,max))

#tidy up
sapply(Weather,apply, 1 ,max) #<< del3
sapply(Weather,apply, 1 ,min) #<< del4


#to find the index of the max and min
?which.max()
Chicago
which.max(Chicago[1,])
names(which.max(Chicago[1,])) #returns the index of the max/ min value
#add own function into apply [wanted function not in built in]
apply(Chicago, 1, function(x) names(which.max(x)))
#nest apply into sapply [wanted function not in built in]
sapply (Weather, function(y) apply(y, 1, function(x) names(which.max(x))) ) #<< Del 5









