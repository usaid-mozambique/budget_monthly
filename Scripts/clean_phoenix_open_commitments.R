library(tidyverse)
library(blingr)


INPUT_PATH = "Data/open_commitment/raw/"
OUTPUT_PATH = "Dataout/"


#raw data from phoenix
open_commitments_file <- paste0(INPUT_PATH, "Phoenix_Open Commitments Detailed.xlsx")

#read file - no blank lines
open_commitments_data <- readxl::read_xlsx(open_commitments_file)

#clean data - keep non_pepfar data from Mozambique operating unit
open_commitments <- blingr::clean_phoenix_open_commitments(open_commitments_data) 

#write data
write_csv(open_commitments, paste0(OUTPUT_PATH,"clean_phoenix_open_commitments.csv"))