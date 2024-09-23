library(tidyverse)
library(blingr)
library(janitor)



DOAG_DATE <- readxl::read_xlsx("Data/DOAG Amendment Obligation Dates.xlsx") |> 
    clean_names() |> 
    select(-c(amendment_number, development_objective))


#path where all files are stored.  They should be in the same format
BI_ACC_LINES_HISTORY_PATH = "Data/bi_acc_lines/processed/pepfar/"

#list of all xlsx files in the directory
bi_acc_lines_all_files <- dir(BI_ACC_LINES_HISTORY_PATH,
                              full.name = TRUE,
                              pattern = "*.xlsx")

pepfar_all_bi_acc_lines <- map(bi_acc_lines_all_files, ~ blingr::create_history_bi_oblg_acc_lines(.x, TRUE)) |> 
    bind_rows() |> 
    left_join(DOAG_DATE, by = c('Document Number' = "document_number")) 
    

#write data
write_csv(pepfar_all_bi_acc_lines, "Dataout/pepfar_all_bi_oblg_acc_lines.csv")


# path to where all files are stored
OPEN_COMMITMENTS_HISTORY_PATH <-  "Data/open_commitment/processed/pepfar/"

#create a list of all files in the director.  NB: data needs to be on the first tab
open_commitments_all_files <- dir(OPEN_COMMITMENTS_HISTORY_PATH,
                                  full.name = TRUE,
                                  pattern = "*.xlsx")

#combine all datasets into one and add period based on file name
pepfar_all_open_commitments <- map(open_commitments_all_files, blingr::create_history_open_commitments)  |> 
    bind_rows()

#write data
write_csv(pepfar_all_open_commitments, "Dataout/pepfar_all_open_commitments.csv")

