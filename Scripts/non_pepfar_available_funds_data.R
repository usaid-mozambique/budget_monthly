library(tidyverse)
library(blingr)


#-----------------------------------------------------------------
PROGRAM_AREA_EXCLUDE_FILTER <- "HL.1" #PEPFAR program area
FUNDING_OFFICE_CODE_FILTER <- "IHO"
AVAIL_FOR_SUBOBL_AMT_FILTER <- 1
OPERATING_UNIT_FILTER <- "MOZAMBIQUE" 


#CLEAN ONE FILE ----------------------------------------------------

#raw data from phoenix
bi_acc_lines_file <-  "Data/bi_acc_lines/raw/Bilateral Accounting Lines.xlsx"

#read file - no blank lines
bi_acc_lines_data <- readxl::read_excel(bi_acc_lines_file)

#clean data - keep non_pepfar data with a minimum avail for subobl amount
bi_acc_lines_non_pepfar <- blingr::clean_phoenix_bi_oblg_acc_lines(bi_acc_lines_data) |> 
    filter(`Program Area` != PROGRAM_AREA_EXCLUDE_FILTER,
           `Funding Office Code` == FUNDING_OFFICE_CODE_FILTER,
           `Avail for Subobl Amt` > AVAIL_FOR_SUBOBL_AMT_FILTER)

#write data
write_csv(bi_acc_lines_non_pepfar, "Dataout/non_pepfar_bi_oblg_acc_lines_test.csv")

#raw data from phoenix
open_commitments_file <- "Data/open_commitment/raw/Phoenix_Open Commitments Detailed.xlsx"

#read file - no blank lines
open_commitments_data <- readxl::read_xlsx(open_commitments_file)

#clean data - keep non_pepfar data from Mozambique operating unit
non_pepfar_open_commitments <- blingr::clean_phoenix_open_commitments(open_commitments_data) |> 
    filter(
        funding_office_code == FUNDING_OFFICE_CODE_FILTER,
        program_area != PROGRAM_AREA_EXCLUDE_FILTER,
        operating_unit == OPERATING_UNIT_FILTER
    )


#write data
write_csv(non_pepfar_open_commitments, "Dataout/non_pepfar_open_commitments.csv")


#COMBINE ALL MONTHS.  After data has been udpated by team ------------------------------------------------------

#path where all files are stored.  They should be in the same format
BI_ACC_LINES_HISTORY_PATH <-  "Data/bi_acc_lines/processed/non_pepfar"

#list of all xlsx files in the directory
bi_acc_lines_all_files <- dir(BI_ACC_LINES_HISTORY_PATH,
                              full.name = TRUE,
                              pattern = "*.xlsx")

#combine all datasets into one and add period based on file name: Reshape and add comments
non_pepfar_all_bi_acc_lines <- map(bi_acc_lines_all_files, ~ blingr::create_history_bi_oblg_acc_lines(.x, FALSE)) |> 
    bind_rows()

#write data
write_csv(non_pepfar_all_bi_acc_lines, "Dataout/non_pepfar_all_bi_oblg_acc_lines.csv")

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
