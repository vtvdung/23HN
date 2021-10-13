# link 23HN data

# libraries
library(dplyr)
# path


# functions
'%ni%' <- Negate('%in%')

## read data

# (1) Skb: logbook of Trang An CHC
for (i in readxl::excel_sheets("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx")){
  
  if(exists("skb")){
    skb <- rbind(skb,readxl::read_excel("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx",
                                        sheet = i,col_types = "text")  )
    
  }else{
    skb <- readxl::read_excel("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx",
                              sheet = i,col_types = "text")
    
    }
  
  
}



# (2) Member information from survey





## curate data
# (1) skb --> logbook
skb$UniqueID <- paste("R_",formatC(1:nrow(skb),width = 7, format = "d", flag = "0"))
logbook <- skb
names(logbook) <- c("No","logbookNo","Date_raw","Name","Gender(Male1)","Age_YoB","HIN","Address","Occupation","Ethnic",
                    "Symptom","Diagnosis","Prescription","Prescriber","Note","UniqueID")
logbook %>% filter(!is.na(No) & !is.na(Name) & Name!="") %>% mutate(Date = as.Date(as.numeric(Date_raw), origin = "1899-12-30"),
                                                                    year=ifelse(is.na(Date),2019, lubridate::year(Date)),
                                                                    Age = ifelse(as.numeric(Age_YoB)>1900,year-as.numeric(Age_YoB)+1,as.numeric(Age_YoB)))-> logbook


# check data
apply(X = logbook[,c("Date","Gender","Age_YoB","Address")],MARGIN = 2,unique)
apply(X = logbook[,c("Name","Date","Gender","Age_YoB","Address")],MARGIN = 2,function(x){sum(is.na(x))})






