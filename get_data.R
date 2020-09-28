source(here::here('REST_API/src/plumber.R'))

links = all.links()
d = scrape.all.info(links)
date = format(today(), "%d_%h_%Y")  %>% as.character()
filename = paste0('imm_',date,'.csv')
write.csv(d, file = here::here(paste0("/shared-data/",filename)))
