source(here::here("scraping/_links.R"),echo = FALSE)
source(here::here("scraping/_complete.R"),echo = FALSE)

links = all.links()
date = format(lubridate::today(), "%d-%b-%Y")  %>% as.character()
filename = paste0('shared-data/imm-',date,'.csv')
all = scrape.all.info(links = links)

cat("writing .csv file...")
write.csv(x = all, file = filename, append = T)  
