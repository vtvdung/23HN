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
survey <- readxl::read_excel("..\\...\\..\\..\\..\\..\\vtvdu/PH Epidemiology Dropbox/23HN_Data/23HN draft papers/Data/Raw/31-5-2021-_23HN_V1_Data.xls",sheet = "MEMBER")




## curate data
# (1) skb --> logbook
skb$UniqueID <- paste("R_",formatC(1:nrow(skb),width = 7, format = "d", flag = "0"))
logbook <- skb
names(logbook) <- c("No","logbookNo","Date_raw","Fullname","Gender(Male1)","Age_YoB","HIN","Address","Occupation","Ethnic",
                    "Symptom","Diagnosis","Prescription","Prescriber","Note","UniqueID")
logbook %>% filter(!is.na(No) & !is.na(Fullname) & Fullname!="") %>% mutate(Date = as.Date(as.numeric(Date_raw), origin = "1899-12-30"),
                                                                    year=ifelse(is.na(Date),2019, lubridate::year(Date)),
                                                                    Age = ifelse(as.numeric(Age_YoB)>1900,year-as.numeric(Age_YoB)+1,as.numeric(Age_YoB)))-> logbook



# split fullname into Initial (without name), InitialF (with name) and Name
logbook[,c("Initial","InitialF","Name")] <-  apply(X = logbook[,"Fullname"],MARGIN = 1,function(x){
  strsplit(x["Fullname"],split = " ")[[1]]-> tmp; 
  Name <- tmp[length(tmp)]
  Initial <- paste(substr(tmp[1:(length(tmp)-1)],1,1),collapse = "")
  InitialF <- paste(substr(tmp[1:length(tmp)],1,1),collapse = "")
  toupper(c(Initial,InitialF,Name))
  }) %>% as.data.frame() %>% t

# check data
#apply(X = logbook[,c("Date","Gender(Male1)","Age_YoB","Address")],MARGIN = 2,table)
#apply(X = logbook[,c("Fullname","Date","Gender(Male1)","Age_YoB","Address")],MARGIN = 2,function(x){sum(is.na(x))})
#


# correct data
logbook$Gender <- logbook$`Gender(Male1)`
logbook$Gender[logbook$Gender %in% c("1950","3")] <- "1"

# check data
apply(X = logbook[,c("Date","Gender","Age","Address")],MARGIN = 2,table)

# subset data, keep only patients from Trang An - Ha Nam
logbook <- subset(logbook,subset = (Address %in% c("TA","TRÀNG AN","HÀ NAM")))

# (2) Survey
survey$INITIAL <- toupper(survey$INITIAL)
survey$MEMNAME <- toupper(survey$MEMNAME)
survey$Survey_ID <- paste("R_",formatC(1:nrow(survey),width = 4, format = "d", flag = "0"))

## COMPARE DATA
# compare name
sum(survey$MEMNAME %in% logbook$)

# compare initial








