
# 1. The training and the test sets were merged to create one data set

train <- read.table("train/X_train.txt")
test <- read.table("test/X_test.txt")
X_data <- rbind(train, test)

train <- read.table("train/subject_train.txt")
test <- read.table("test/subject_test.txt")
Subject_data <- rbind(train, test)

train <- read.table("train/y_train.txt")
test <- read.table("test/y_test.txt")
Y_data <- rbind(train, test)

# 2. The measurements on the mean and standard deviation for each measurement.

measurements <- select(X_data, subjects, V1, contains(".mean."), contains(".std."))
measurements$subjects <- as.factor(measurements$subjects)
measurements$V1 <- as.factor(measurements$V1)

# 3. Descriptive activity names are used to name the activities in the data set.

measurements$V1 <- mapvalues(measurements$V1, from = c("1", "2", "3", "4", "5", "6"), 
                         to = c("Walking", "WalkingUpStairs", "WalkingDownStairs", "Sitting", "Standing", "Lying"))

# 4. The data is labeled with descriptive activity names.

names(Subject_data) <- "subject"
descriptive_names <- cbind(Subject_data, Y_data, X_data)

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

group_by(Subject_data, measurements) %>%
summarise_each(funs(mean))
write.table(descriptive_names, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)
