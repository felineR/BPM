##Read in reference data
features <- read.table("features.txt")
act_labs <- read.table("activity_labels.txt")

##Read in and merge test data
testX <- read.table("test/X_test.txt")
names(testX) <- features$V2
testY <- read.table("test/y_test.txt")
testY <- merge(testY, act_labs)
test <- cbind(testX, testY[,2])
names(test)[ncol(test)] <- "Activity Label"
rm(testX, testY)

##Read in and merge train data
trainX <- read.table("train/X_train.txt")
names(trainX) <- features$V2
trainY <- read.table("train/y_train.txt")
trainY <- merge(trainY, act_labs)
train <- cbind(trainX, trainY[,2])
names(train)[ncol(train)] <- "Activity Label"
rm(trainX, trainY)

##Merge test and train data
merged <- rbind(test, train)
rm(test, train, act_labs, features)

##Exract columns on standard deviation and mean
names <- names(merged)
std <- grep("std", names)
std_merged <- merged[, std]
mean <- grep("mean", names)
mean_merged <- merged[, mean]
filtered <- cbind(mean_merged, std_merged, merged[, ncol(merged)])
names(filtered)[ncol(filtered)] <- "Activity Label"
rm(std, mean, names, merged, mean_merged, std_merged)

##Improve labeling
names <- names(filtered)
names <- gsub("-", " ", names)
names <- gsub("mean", "Mean", names)
names <- gsub("std", "Standard Deviation", names)
names(filtered) <- names
rm(names)

##Average values for each activity and subject
averaged <- aggregate(filtered[,1:(ncol(filtered)-1)], by=list(act_lab=filtered$`Activity Label`), FUN=mean)

##Write data frames into file system
write.csv(filtered, "filtered.csv")
write.csv(averaged, "averaged.csv")
rm(averaged, filtered)