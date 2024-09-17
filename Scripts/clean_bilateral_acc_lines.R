library(tidyverse)
library(blingr)



#CLEAN ONE FILE ----------------------------------------------------

bi_acc_lines_file = "Data/bi_acc_lines/raw/Bilateral Accounting Lines.xlsx"


bi_acc_lines_data <- readxl::read_excel(bi_acc_lines_file)
bi_acc_lines <- blingr::clean_phoenix_bi_oblg_acc_lines(bi_acc_lines_data)

write_csv(bi_acc_lines, "Dataout/bi_oblg_acc_lines.csv")


#CREATE HISTORY------------------------------------------------------
BI_ACC_LINES_HISTORY_PATH = "Data/bi_acc_lines/processed/"

bi_acc_lines_all_files <- dir(BI_ACC_LINES_HISTORY_PATH,
                   full.name = TRUE,
                    pattern = "*.xlsx")


all_bi_acc_lines <- map(bi_acc_lines_all_files, blingr::create_history_bi_oblg_acc_lines) |> 
    bind_rows()

write_csv(all_bi_acc_lines, "Dataout/all_bi_oblg_acc_lines.csv")
