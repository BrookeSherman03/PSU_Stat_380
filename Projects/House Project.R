#libraries to use
library(dplyr)
library(data.table)

#load data
house <- fread("./Data/Stat_380_housedata.csv")
qc <- fread("./Data/Stat_380_QC_table.csv")

combine <- merge(house, qc)

test <- house %>% filter(grepl('test', Id))
train <- house %>% filter(grepl('train', Id))

#finding the average sale price based upon the qc_code
new <- house[,.(mean_saleprice=mean(SalePrice,na.rm = T)),by = qc_code]

#sorting the test ids
change <- (substring(test$Id, first = 6))
change <- strtoi(change)
test$num <- change
setorder(test, num)

new_df <- data.frame(test$Id, test$qc_code, test$num)
setnames(new_df, old = c("test.Id","test.qc_code"), new = c("Id","qc_code"))
ans <- merge(new_df, new, by = "qc_code")
setorder(ans, test.num)

ans <- select(ans, -test.num, -qc_code)
setnames(ans, old = 'mean_saleprice', new = 'SalePrice')
