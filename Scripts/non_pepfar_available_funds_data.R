library(tidyverse)
library(blingr)
library(janitor)

#COMBINE ALL MONTHS.  After data has been udpated by team ------------------------------------------------------
#1. OBLIGATIONS AND ACCRUALS-----------------------------------------
DOAG_DATE <- readxl::read_xlsx("Data/DOAG Amendment Obligation Dates.xlsx") |> 
    clean_names() |> 
    select(-c(amendment_number, development_objective))


#path where all files are stored.  They should be in the same format
BI_ACC_LINES_HISTORY_PATH <-  "Data/bi_acc_lines/processed/non_pepfar"

#list of all xlsx files in the directory
bi_acc_lines_all_files <- dir(BI_ACC_LINES_HISTORY_PATH,
                              full.name = TRUE,
                              pattern = "*.xlsx")

#combine all datasets into one and add period based on file name: Reshape and add comments
non_pepfar_all_bi_acc_lines_mech<- map(bi_acc_lines_all_files, ~ blingr::create_bi_oblg_acc_lines_updated_mech(.x, FALSE)) |> 
    bind_rows() 
write_csv(non_pepfar_all_bi_acc_lines_mech, "Dataout/non_pepfar_all_bi_oblg_acc_lines_mech.csv")


non_pepfar_all_bi_acc_lines_no_mech <- map(bi_acc_lines_all_files, ~ blingr::create_bi_oblg_acc_lines_updated_no_mech(.x, FALSE)) |> 
    bind_rows() |> 
    left_join(DOAG_DATE, by = c('Document Number' = "document_number"))
    
write_csv(non_pepfar_all_bi_acc_lines_no_mech, "Dataout/non_pepfar_all_bi_oblg_acc_lines_no_mech.csv")


#2. OPEN COMMITMENTS-----------------------------------------

#path where all files are stored.  They should be in the same format
OPEN_COMMITMENTS_HISTORY_PATH <-  "Data/open_commitment/processed/non_pepfar"

#create a list of all files in the director.  NB: data needs to be on the first tab
open_commitments_all_files <- dir(OPEN_COMMITMENTS_HISTORY_PATH,
                                  full.name = TRUE,
                                  pattern = "*.xlsx")

#combine all datasets into one and add period based on file name
non_pepfar_all_open_commitments <- map(open_commitments_all_files, blingr::create_history_open_commitments)  |> 
    bind_rows()

#write data
write_csv(non_pepfar_all_open_commitments, "Dataout/non_pepfar_all_open_commitments.csv")
