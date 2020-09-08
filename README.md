# Getting_and_Cleaning_Data

Project of week4 of the course from rep. name

At the begining we fetch enumaration list for features and names.

In the next step we merge files for train and test sets form subdirectory Inertial Signals (body_acc_x\*, etc.)

Then we merge main files in the main directory for training set and test set (subject\*, X\* and y\*).

As a result of the step 1. we get data frame big_data. It is created as merge of subject numbers, activity description and data about each measument with the corresponding column names. As a final step we merge data sets from Inertial Signals directory with big_data data frame. Final data frame is stored as joint_all.txt (remark: it can not be uploaded into GIT, since the size exceeds the limit of GIT).

Step 2 - the file joint_all_smaller.txt is created from joint_all.txt by filtering away columns which do not contain "mean" or "std" the the column name.

Steps 3 a 4 were solved during the step 1.

The last step 5 is stored in joint_all_smaller_groupped.txt, where data were calculated by grouping. We calculate mean for the subject and each activity for all variables stored in the file joint_all_smaller.txt.

