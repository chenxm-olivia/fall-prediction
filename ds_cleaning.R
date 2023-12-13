library(haven)
library(tidyverse)
library(tableone)

source("utils.R")

# Import data sets
ds_r1 <- import_ds("source_data","NHATS_Round_1_SP_File.sas7bdat") 
ds_r2 <- import_ds("source_data","NHATS_Round_2_SP_File_v2.sas7bdat") 

# Sample selection
ds_r1_clean <- ds_r1 %>% filter(resid <= 2 & !(cm9==1) & !(glasseswr==7)) %>%
  select(-resid,-fllsinmth,-faleninyr,-multifall,-sppbmiss,-round,-gender) %>% 
  filter(complete.cases(.))
  
ds_r2_clean <- left_join(ds_r1_clean %>% select(spid), ds_r2, by = "spid") %>% 
  rename(fallstat1y = fallstat, anyfall1y = anyfall) %>% 
  select(spid, fallstat1y, anyfall1y) %>% filter(complete.cases(.))

# Data cleaning
ds_clean <- left_join(ds_r1_clean, ds_r2_clean, by = "spid") %>%
  mutate(multifall1y = ifelse(fallstat1y==2,1,ifelse(is.na(fallstat1y),NA,0)),
         multifall = ifelse(fallstat==2,1,ifelse(is.na(fallstat),NA,0))) %>%
  select(-cm9) %>% filter(complete.cases(.))

ds_clean$raceth <- ifelse(ds_clean$raceth == 5, 3, ds_clean$raceth) %>%
  factor(levels = 1:4, labels = c("Wh", "Bl", "Oth", "Hisp")) %>% relevel(ref = "Wh")

ds_clean$edu <- ifelse(ds_clean$edu <=3, 1, ifelse(ds_clean$edu==4, 2, 3)) %>%
  factor(levels = 1:3, labels = c("<HS", "HS", ">HS")) %>% relevel(ref = ">HS")

summary(ds_clean)

# Save data set
ds_clean %>% write_csv("derived_data/ds_clean.csv")

# Check data distribution
varlist <- ds_clean %>% select(-spid, -multifall1y, -anyfall1y, -fallstat1y) %>% names()
varlist_f <- ds_clean %>% select(-spid, -multifall1y, -anyfall1y, -fallstat1y, -depresan2, -sppb, -sppb_walk, -sppb_chair, -sppb_balance) %>% names()

table1 <- CreateTableOne(vars = varlist, strata = c("fallstat1y"), 
                         data = ds_clean %>% mutate(across(varlist_f, as.factor)))
print(table1)
