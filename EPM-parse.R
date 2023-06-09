library(tidyverse)
library(readxl)
Nweekdays <- Vectorize(
  function(a, b) 
  {
    ifelse(a < b, 
           return(0 - (sum(!weekdays(seq(a, b, "days")) %in% c("Saturday", "Sunday")) - 1)), 
           return(sum(!weekdays(seq(b, a, "days")) %in% c("Saturday", "Sunday")) - 1))
  })

########2020###########
Sys.setlocale()
df_2020 <- read_excel("EPM ÅR 2020.xlsx")
df_2020_diff <- df_2020 %>% 
  mutate(diff = difftime(`Beslutsdatum`, `Ink datum`, units="days")) %>% 
  filter (diff > 0) 

df_2020_grouped_by_fee <-
  df_2020_diff %>%
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff), median = median(diff), sd = sd(diff), n=n())

df_2020_grouped_by_decision <-
  df_2020_diff %>%
  group_by(Beslut) %>% 
  summarize(mean = mean(diff), median = median(diff), sd = sd(diff), n=n())

#Counting all missing as 0
df_2020_diff_0values <- 
  df_2020_diff <- df_2020 %>% 
  mutate(diff = difftime(`Beslutsdatum`, `Ink datum`, units="days")) %>% 
  mutate(diff_2 = ifelse(!is.na(diff) & diff > 0, diff, 0))  

df_2020_grouped_by_fee_0values <-
  df_2020_diff_0values %>%
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff_2), median = median(diff_2), sd = sd(diff_2), n=n())

df_2020_grouped_by_decision_0values <-
  df_2020_diff_0values %>%
  group_by(Beslut) %>% 
  summarize(mean = mean(diff),median = median(diff_2),  sd = sd(diff), n=n())

#Counting weekdays
Sys.setlocale(category="LC_ALL", locale = "English_United States.1252")

df_2020_diff_wd <- df_2020 %>% 
  mutate(diff = Nweekdays(`Beslutsdatum`, `Ink datum`)) %>% 
  filter (diff > 0) 

df_2020_grouped_by_fee_wd <-
  df_2020_diff_wd %>%
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff), median = median(diff), sd = sd(diff), n=n())

df_2020_grouped_by_decision_wd <-
  df_2020_diff_wd %>%
  group_by(Beslut) %>% 
  summarize(mean = mean(diff), median = median(diff),  sd = sd(diff), n=n())


#Counting all missing as 0 and only weekdays
df_2020_diff_0values_wd <- df_2020 %>% 
  mutate(diff = Nweekdays(`Beslutsdatum`, `Ink datum`)) %>% 
  mutate(diff_2 = ifelse(!is.na(diff) & diff > 0, diff, 0))  

df_2020_grouped_by_fee_0values_wd <-
  df_2020_diff_0values_wd %>%
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff_2),median = median(diff_2),  sd = sd(diff_2), n=n())

df_2020_grouped_by_decision_0values_wd <-
  df_2020_diff_0values_wd %>%
  group_by(Beslut) %>% 
  summarize(mean = mean(diff),median = median(diff_2),  sd = sd(diff), n=n())


########2021###########
df_2021 <- read_excel("EPM ÅR 2021.xlsx")
df_2021_diff <- df_2021 %>% 
  mutate(diff = difftime(`Slutligt beslut datum`, `Inkomstdatum`, units="days")) %>% 
  filter (diff > 0)

df_2021_grouped_by_fee <-
  df_2021_diff %>% 
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff), sd = sd(diff), n=n())

df_2021_grouped_by_decision <-
  df_2021_diff %>% 
  group_by(`Typ av slutligt beslut`) %>% 
  summarize(mean = mean(diff), sd = sd(diff), n=n())

########2023###########
df_2022 <- read_excel("EPM ÅR 2022.xlsx")
df_2022_diff <- df_2022 %>% 
  mutate(diff = difftime(`Slutligt beslut datum`, `Inkom datum`, units="days")) %>% 
  filter (diff > 0)

df_2022_grouped_by_fee <-
  df_2022_diff %>% 
  group_by(Avgiftskategori) %>% 
  summarize(mean = mean(diff), sd = sd(diff), n=n())

df_2022_grouped_by_decision <-
  df_2022_diff %>% 
  group_by(`Typ av slutligt beslut`) %>% 
  summarize(mean = mean(diff), sd = sd(diff), n=n())

#######OUT#########

outputs <- list(df_2020_grouped_by_fee,df_2020_grouped_by_decision,df_2021_grouped_by_fee,df_2021_grouped_by_decision,df_2022_grouped_by_fee,df_2022_grouped_by_decision)
output_names <- c("df_2020_grouped_by_fee.csv","df_2020_grouped_by_decision.csv","df_2021_grouped_by_fee.csv","df_2021_grouped_by_decision.csv","df_2022_grouped_by_fee.csv","df_2022_grouped_by_decision.csv")

for (i in 1:6) {
  write.csv(outputs[i], output_names[i], row.names = F)
}

