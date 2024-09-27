library(tidyverse)
library(blingr)
library(janitor)



#Abbreviations--------------------------------------------------------
# Create a named vector for lookup
program_element_map <- c(
    "HL.1.11" = "HTXS",
    "HL.1.13" = "OHSS",
    "HL.1.17" = "PDCS",
    "HL.1.8"  = "HKID",
    "HL.1.2"  = "HVAB",
    "HL.1.5"  = "HVOP",
    "HL.1.9"  = "HVCT",
    "HL.1.14" = "HIS",
    "HL.1.15" = "CIRC",
    "HL.1.19" = "HVMS"
)


#COMBINE ALL MONTHS.  After data has been udpated by team ------------------------------------------------------
#1. OBLIGATIONS AND ACCRUALS-----------------------------------------
DOAG_DATE <- readxl::read_xlsx("Data/DOAG Amendment Obligation Dates.xlsx") |> 
    clean_names() |> 
    select(-c(amendment_number, development_objective))


#path where all files are stored.  They should be in the same format
BI_ACC_LINES_HISTORY_PATH = "Data/bi_acc_lines/processed/pepfar/"

#list of all xlsx files in the directory
bi_acc_lines_all_files <- dir(BI_ACC_LINES_HISTORY_PATH,
                              full.name = TRUE,
                              pattern = "*.xlsx")

#combine all datasets into one and add period based on file name: Reshape and add comments
pepfar_all_bi_acc_lines_mech<- map(bi_acc_lines_all_files, ~ blingr::create_bi_oblg_acc_lines_updated_mech(.x, TRUE)) |> 
    bind_rows() 
write_csv(pepfar_all_bi_acc_lines_mech, "Dataout/pepfar_all_bi_oblg_acc_lines_mech.csv")


pepfar_all_bi_acc_lines_no_mech <- map(bi_acc_lines_all_files, ~ blingr::create_bi_oblg_acc_lines_updated_no_mech(.x, TRUE)) |> 
    bind_rows() |> 
    left_join(DOAG_DATE, by = c('Document Number' = "document_number")) |> 
    mutate(abbrev = recode(`Program Element`, !!!program_element_map, .default = ""))

write_csv(pepfar_all_bi_acc_lines_no_mech, "Dataout/pepfar_all_bi_oblg_acc_lines_no_mech.csv")

#2. OPEN COMMITMENTS-----------------------------------------
# path to where all files are stored
OPEN_COMMITMENTS_HISTORY_PATH <-  "Data/open_commitment/processed/pepfar/"

#create a list of all files in the director.  NB: data needs to be on the first tab
open_commitments_all_files <- dir(OPEN_COMMITMENTS_HISTORY_PATH,
                                  full.name = TRUE,
                                  pattern = "*.xlsx")

#combine all datasets into one and add period based on file name
pepfar_all_open_commitments <- map(open_commitments_all_files, blingr::create_history_open_commitments)  |> 
    bind_rows() |> 
    mutate(abbrev = recode(program_element, !!!program_element_map, .default = ""))

#write data
write_csv(pepfar_all_open_commitments, "Dataout/pepfar_all_open_commitments.csv")
