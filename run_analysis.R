
library('plyr')

library('reshape2')

# get all column names for the data
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# flag the standard deviation and mean features to get
activity_to_fetch <- grepl("mean|std", features)

# collect all activity names
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]

testX <- read.table("./UCI HAR Dataset/Test/X_test.txt")
testY <- read.table("./UCI HAR Dataset/Test/y_test.txt")
testSubject <- read.table("./UCI HAR Dataset/Test/subject_test.txt")

trainX <- read.table("./UCI HAR Dataset/Train/X_train.txt")
trainY <- read.table("./UCI HAR Dataset/Train/y_train.txt")
trainSubject <- read.table("./UCI HAR Dataset/Train/subject_train.txt")

# add the activity to the last column
testY[,2] = activity_labels[testY[,1]]
trainY[,2] = activity_labels[trainY[,1]]

# name the columns
names(testSubject) <- "Subject"
names(trainSubject) <- "Subject"
names(testY) <- c("ActivityCode", "ActivityName")
names(trainY) <- c("ActivityCode", "ActivityName")

# set the labels for the test data columns
names(testX) = features
names(trainX) = features

# now filter only the featured needed to fetch (std dev and mean) 
testX = testX[,activity_to_fetch]
trainX = trainX[,activity_to_fetch]

# bind data to get the complete test values
testData <- cbind(testSubject, testY, testX)
trainData <- cbind(trainSubject, trainY, trainX)

# merge test and train data to get the complete set
alldata <- rbind(testData, trainData)

# get the labels on subject-activity for mean calculation grouping
meltLabels <- c("Subject", "ActivityCode", "ActivityName")

# get all labels to run mean
activityForMean = setdiff(colnames(alldata), meltLabels)

# get unique data set ready for casting
meltedData  = melt(alldata, id = meltLabels, measure.vars = activityForMean)

# run dcast with mean function to execute
cleanData   = dcast(meltedData, Subject + ActivityName ~ variable, mean)

# write the cleaned data to file
write.table(cleanData, file = "./cleandata.txt", row.name=FALSE)




