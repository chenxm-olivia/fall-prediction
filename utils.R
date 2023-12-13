library(haven)
library(tidyverse)

# Missing values
make_vals_missing <- function(df, vars, val) {
  for (var in vars) {
    df[[var]][df[[var]] %in% val] <- NA
  }
  return(df)
}

# Yes/No coding
yn_convert <- function(df, vars) {
  for (var in vars) {
    df[[var]][df[[var]] ==2] <- 0
  }
  return(df)
}

# Import specified data set and keep relevant variables
import_ds <- function(dir,source_ds) {
  path <- paste0(dir, "/", source_ds)
  num <- str_split_fixed(source_ds, pattern = "_", n = 4)[1,3]
  col_names_base <- c("spid", paste0("r",num,"dresid"),
                      paste0("r",num,"d2intvrage"),
                      paste0("r",num,"dgender"),
                      paste0("rl",num,"dracehisp"),
                      paste0("el",num,"higstschl"),
                      paste0("md",num,"canewlker"),
                      paste0("hc",num,"fllsinmth"),
                      paste0("hc",num,"faleninyr"),
                      paste0("hc",num,"multifall"),
                      paste0("hc",num,"worryfall"),
                      paste0("hc",num,"depresan2"),
                      paste0("ss",num,"prbbalcrd"),
                      paste0("ss",num,"heringaid"),
                      paste0("ss",num,"hearphone"),
                      paste0("ss",num,"glasseswr"),
                      paste0("ss",num,"seewellst"),
                      paste0("r",num,"dorigsppb"),
                      paste0("r",num,"dorigbasc"),
                      paste0("r",num,"dorigwksc"),
                      paste0("r",num,"dorigchsc"),
                      paste0("r",num,"dsppbmiss"),
                      paste0("hc",num,"disescn1"),
                      paste0("hc",num,"disescn2"),
                      paste0("hc",num,"disescn3"),
                      paste0("hc",num,"disescn4"),
                      paste0("hc",num,"disescn5"),
                      paste0("hc",num,"disescn6"),
                      paste0("hc",num,"disescn7"),
                      paste0("hc",num,"disescn8"),
                      paste0("hc",num,"disescn9"),
                      paste0("hc",num,"disescn10"),
                      paste0("ir",num,"condihom4"),
                      paste0("ir",num,"condihom5"))
  
  col_names_fu <- c("spid", paste0("r",num,"dresid"),
                    paste0("r",num,"d2intvrage"),
                    paste0("md",num,"canewlker"),
                    paste0("hc",num,"fllsinmth"),
                    paste0("hc",num,"faleninyr"),
                    paste0("hc",num,"multifall"),
                    paste0("hc",num,"worryfall"),
                    paste0("hc",num,"depresan2"),
                    paste0("ss",num,"prbbalcrd"),
                    paste0("ss",num,"heringaid"),
                    paste0("ss",num,"hearphone"),
                    paste0("ss",num,"glasseswr"),
                    paste0("ss",num,"seewellst"),
                    paste0("r",num,"dorigsppb"),
                    paste0("r",num,"dorigbasc"),
                    paste0("r",num,"dorigwksc"),
                    paste0("r",num,"dorigchsc"),
                    paste0("r",num,"dsppbmiss"),
                    paste0("hc",num,"disescn1"),
                    paste0("hc",num,"disescn2"),
                    paste0("hc",num,"disescn3"),
                    paste0("hc",num,"disescn4"),
                    paste0("hc",num,"disescn5"),
                    paste0("hc",num,"disescn6"),
                    paste0("hc",num,"disescn7"),
                    paste0("hc",num,"disescn8"),
                    paste0("hc",num,"disescn9"),
                    paste0("hc",num,"disescn10"),
                    paste0("ir",num,"condihom4"),
                    paste0("ir",num,"condihom5"))
  if(num == "1") {
    ds <- read_sas(path) %>% 
      rename_all(tolower) %>% 
      select(all_of(col_names_base)) %>%
      rename("resid" = col_names_base[2],
             "age" = col_names_base[3],
             "gender" = col_names_base[4],
             "raceth" = col_names_base[5],
             "edu" = col_names_base[6],
             "canewlker" = col_names_base[7],
             "fllsinmth" = col_names_base[8],
             "faleninyr" = col_names_base[9],
             "multifall" = col_names_base[10],
             "worryfall" = col_names_base[11],
             "depresan2" = col_names_base[12],
             "prbbalcrd" = col_names_base[13],
             "heringaid" = col_names_base[14],
             "hearphone" = col_names_base[15],
             "glasseswr" = col_names_base[16],
             "seewellst" = col_names_base[17],
             "sppb" = col_names_base[18],
             "sppb_balance" = col_names_base[19],
             "sppb_walk" = col_names_base[20],
             "sppb_chair" = col_names_base[21],
             "sppbmiss" = col_names_base[22],
             "cm1" = col_names_base[23],
             "cm2" = col_names_base[24],
             "cm3" = col_names_base[25],
             "cm4" = col_names_base[26],
             "cm5" = col_names_base[27],
             "cm6" = col_names_base[28],
             "cm7" = col_names_base[29],
             "cm8" = col_names_base[30],
             "cm9" = col_names_base[31],
             "cm10" = col_names_base[32],
             "condihom4" = col_names_base[33],
             "condihom5" = col_names_base[34]) %>%
      mutate(round = as.numeric(num))

    ds <- make_vals_missing(ds, c("raceth"), 6)
    ds <- make_vals_missing(ds, c("edu"), c(-1,-7,-8,-9))
    ds <- ds %>% mutate(female = gender-1)
    
  } else {
    ds <- read_sas(path) %>% 
      rename_all(tolower) %>% 
      select(all_of(col_names_fu)) %>%
      rename("resid" = col_names_fu[2],
             "age" = col_names_fu[3],
             "canewlker" = col_names_fu[4],
             "fllsinmth" = col_names_fu[5],
             "faleninyr" = col_names_fu[6],
             "multifall" = col_names_fu[7],
             "worryfall" = col_names_fu[8],
             "depresan2" = col_names_fu[9],
             "prbbalcrd" = col_names_fu[10],
             "heringaid" = col_names_fu[11],
             "hearphone" = col_names_fu[12],
             "glasseswr" = col_names_fu[13],
             "seewellst" = col_names_fu[14],
             "sppb" = col_names_fu[15],
             "sppb_balance" = col_names_fu[16],
             "sppb_walk" = col_names_fu[17],
             "sppb_chair" = col_names_fu[18],
             "sppbmiss" = col_names_fu[19],
             "cm1" = col_names_fu[20],
             "cm2" = col_names_fu[21],
             "cm3" = col_names_fu[22],
             "cm4" = col_names_fu[23],
             "cm5" = col_names_fu[24],
             "cm6" = col_names_fu[25],
             "cm7" = col_names_fu[26],
             "cm8" = col_names_fu[27],
             "cm9" = col_names_fu[28],
             "cm10" = col_names_fu[29],
             "condihom4" = col_names_fu[30],
             "condihom5" = col_names_fu[31]) %>%
      mutate(round = as.numeric(num))
  }
  
  ds <- make_vals_missing(ds, c("canewlker","fllsinmth","faleninyr","multifall","worryfall","depresan2",
                                "prbbalcrd","heringaid","hearphone","glasseswr","seewellst","sppb",
                                "sppb_balance","sppb_walk","sppb_chair","sppbmiss",
                                "cm1","cm2","cm3","cm4","cm5","cm6","cm7","cm8","cm9","cm10",
                                "condihom4","condihom5"), c(-1,-7,-8,-9))
  ds <- ds %>% mutate(fallstat = ifelse((fllsinmth==1 | faleninyr==1) & multifall==1,2, 
                                        ifelse((fllsinmth==1 | faleninyr==1) & multifall==2,1,
                                               ifelse(fllsinmth==2 & faleninyr==2,0,NA))),
                      anyfall = ifelse(fllsinmth==1 | faleninyr==1,1,
                                       ifelse(fallstat==0,0,NA)))
  ds <- yn_convert(ds, c("canewlker","worryfall","prbbalcrd","heringaid","hearphone","glasseswr","seewellst",
                         "cm1","cm2","cm3","cm4","cm5","cm6","cm7","cm8","cm9","cm10","condihom4","condihom5"))
                      
  return(ds)
}

# Calculate sensitivity, specificity, PPV, NPV
valid_measures <- function(df){
  df$sens <- (df$n[4]) / (df$n[4] + df$n[3])
  df$spec <- (df$n[1]) / (df$n[2] + df$n[1])
  df$ppv <- (df$n[4]) / (df$n[2] + df$n[4])
  df$npv <- (df$n[1]) / (df$n[1] + df$n[3])
  
  return(df)
}