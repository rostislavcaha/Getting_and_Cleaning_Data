## Enum tables
activity <- read.table("UCI HAR Dataset\\activity_labels.txt")
names(activity) <- c("activity", "activity_text")

features <- read.table("UCI HAR Dataset\\features.txt")
names(features) <- c("id.f", "feature_text")

###################################

library("dplyr")
library("tidyselect")

###################################

merge_files <- function (a,b,c){
      data.a <- read.table(a)
      data.a <- mutate(data.a,type="train")
      data.b <- read.table(b)
      data.b <- mutate(data.b,type="test")
      if(!dir.exists(dirname(c)))
            dir.create(dirname(c),recursive=TRUE)
      write.csv(x=bind_rows(as.data.frame(data.a),as.data.frame(data.b)),file=c)
}

## acceleration signals and velocity vectors

for(i in c("body_acc_x","body_acc_y","body_acc_z",
           "body_gyro_x","body_gyro_y","body_gyro_z",
           "total_acc_x","total_acc_y","total_acc_z")) {
      merge_files(
            paste("UCI HAR Dataset\\train\\Inertial Signals\\",i,"_train.txt",sep=""),
            paste("UCI HAR Dataset\\test\\Inertial Signals\\",i,"_test.txt",sep=""),
            paste("UCI HAR Dataset\\all\\Inertial Signals\\",i,"_all.txt",sep="")
      )
}

## main files 

for(i in c("subject","X","Y")) {
      merge_files(
            paste("UCI HAR Dataset\\train\\",i,"_train.txt",sep=""),
            paste("UCI HAR Dataset\\test\\",i,"_test.txt",sep=""),
            paste("UCI HAR Dataset\\all\\",i,"_all.txt",sep="")
      )
}

## join main tables

subj <- read.csv("UCI HAR Dataset\\all\\subject_all.txt",header=TRUE)
names(subj) <- c("id.s","subject","type.s")

act <-read.csv("UCI HAR Dataset\\all\\y_all.txt",header=TRUE)
names(act) <- c("id.a","activity","type.a")

data <-read.csv("UCI HAR Dataset\\all\\x_all.txt",header=TRUE)
names(data) <- c("id.n",make.names(features$feature_text),"type.d")

big_data <- bind_cols(subj,act,data)
big_data <- left_join(big_data,activity,by="activity")
big_data <- select(big_data,-c("id.s","id.a","id.n","type.a"))
big_data <- big_data[c(1,2,3,566,4:565)]

# add acceleration signals and velocity vectors

order <- 1:128
for(i in c("body_acc_x","body_acc_y","body_acc_z",
           "body_gyro_x","body_gyro_y","body_gyro_z",
           "total_acc_x","total_acc_y","total_acc_z")) {
      data.f <- read.csv(paste("UCI HAR Dataset\\all\\Inertial Signals\\",i,"_all.txt",sep=""))
      data.f <- data.f[2:129]
      names(data.f) <- c(make.names(paste(i,order,sep=".")))
      big_data <- bind_cols(big_data,data.f)
}

# all data joint into one data set
write.csv(x=big_data,file="UCI HAR Dataset\\all\\joint_all.txt")

# all data joint into one data set (only mean and std columns)
mean_std <- big_data %>% select(contains(c("subject","type.s","activity","activity_text","mean","std")))
write.csv(x=mean_std,file="UCI HAR Dataset\\all\\joint_all_smaller.txt")

# all data joint into one data set (only mean and std columns) averaged by subject and activity
mean_std_g <- mean_std %>% group_by(subject,activity,type.s,activity_text) %>% summarize_all(mean)
write.table(x=mean_std_g,file="UCI HAR Dataset\\all\\joint_all_smaller_groupped.txt",row.name=FALSE)

