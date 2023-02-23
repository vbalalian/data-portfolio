library(tidyverse)
library(readr)
library(skimr)
coins_df_raw <- read_csv('portfolio/roman_coins_raw.csv')
coins_df <- coins_df_raw[, -1]
colnames(coins_df)
head(coins_df)

# split coins_df into 2 dfs, AD and BC, sort appropriately, 
# then merge them again

coins_df %>% 
  filter(metal != 'FAKE', mass < 40) %>%
  group_by(era, year, metal) %>% 
  drop_na(mass) %>% 
  summarize(max_mass = max(mass), 
            mean_mass = mean(mass)) %>%
  arrange(desc(era), as.numeric(year)) %>% 
  View()
  # ggplot() +
  # geom_smooth(mapping=aes(x=year, y=mean_mass)) +
  # geom_jitter(aes(x=year, y=mean_mass, color=metal)) +
  # theme(axis.text.x = element_text(angle = 45)

complete_coins <- coins_df %>% 
  drop_na()

coin_measurables <- select(complete_coins, title, metal, mass, diameter,
                           era, year, inscriptions)
whole_coins_by_ruler <- coin_measurables %>% 
  group_by(title) %>% 
  count() %>% 
  arrange(-n) %>% 
  rename(full_detail_coins = n)

type_of_coins_by_ruler <- coins_df %>% 
  group_by(title, metal) %>% 
  count() %>% 
  arrange(title) %>% 
  pivot_wider(names_from = metal, values_from = n)

coins_df %>% 
  filter(metal != 'FAKE') %>% 
  ggplot() +
  geom_bar(aes(x=metal))
