source(here::here('REST_API/src/plumber.R'))

links = all.links()
d = scrape.all.info(links)
write.csv(d, file = here::here("/shared-data/data.csv"))
