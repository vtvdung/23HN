# link 23HN data

# libraries
library(dplyr)
# path


# functions
'%ni%' <- Negate('%in%')

## read data

# (1) Skb: logbook of Trang An CHC
for (i in readxl::excel_sheets("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx")){
  
  if(!exists("skb")){
    skb <- readxl::read_excel("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx",
                              sheet = i,col_types = "text")
    
  }else{
    skb <- rbind(skb,readxl::read_excel("..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/23HN_SO KHAM BENH (1-9).xlsx",
                                        sheet = i,col_types = "text")  )
    }
  
  
}



# (2) Member information from survey





## curate data
skb$UniqueID <- paste("R_",formatC(1:nrow(skb),width = 7, format = "d", flag = "0"))
logbook <- skb
names(logbook) <- c("No","logbookNo","Date","Name","Gender(Male1)","Age_YoB","HIN","Address","Occupation","Ethnic",
                    "Symptom","Diagnosis","Prescription","Prescriber","Note","UniqueID")


