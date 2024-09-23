library(tidyverse)
library(blingr)


INPUT_PATH = "Data/bi_acc_lines/raw/"
OUTPUT_PATH = "Dataout/"


#raw data from phoenix
bi_acc_lines_file = paste0(INPUT_PATH, "Bilateral Accounting Lines.xlsx")

#read file - no blank lines
bi_acc_lines_data <- readxl::read_excel(bi_acc_lines_file)

#clean data - keep pepfar data with a minimum avail for subobl amount
bi_acc_lines <- blingr::clean_phoenix_bi_oblg_acc_lines(bi_acc_lines_data)

#write data
write_csv(bi_acc_lines, paste0(OUTPUT_PATH,"clean_phoenix_bi_oblg_acc_lines.csv"))