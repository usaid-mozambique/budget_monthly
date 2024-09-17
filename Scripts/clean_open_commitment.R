library(tidyverse)
library(blingr)


# clean one file ----------------------------------------------------------- 

open_commitments_file <- "Data/open_commitment/raw/Phoenix_Open Commitments Detailed.xlsx"

open_commitments_data <- readxl::read_xlsx(open_commitments_file)
open_commitments <- blingr::clean_phoenix_open_commitments(open_commitments_data)

write_csv(open_commitments, "Dataout/open_commitments.csv")

# attach all open commitments files------------------------------------------

# path to where all files are stored
OPEN_COMMITMENTS_HISTORY_PATH <-  "Data/open_commitment/processed/"

#create a list of all files in the director.  NB: data needs to be on the first tab
open_commitments_all_files <- dir(OPEN_COMMITMENTS_HISTORY_PATH,
                 full.name = TRUE,
                 pattern = "*.xlsx")

#read in all files
all_open_commitments <- map(all_files, blingr::create_history_open_commitments)  |> 
    bind_rows()

write_csv(all_open_commitments, "Dataout/all_open_commitments.csv")

