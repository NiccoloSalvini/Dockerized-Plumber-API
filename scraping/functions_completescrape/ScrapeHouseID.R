# Here I collect the ID coming from the second scraping part 
# they are later supposed to be merged in a single DB
# 
# ex. out: (numeric)
# 80198751
# 80774049

scrapehouse.ID= function(session) {
  
  ID = session %>%
    .$url %>% 
    as.character() %>% 
    # str_trunc(45) %>% 
    str_extract('\\d+') %>% 
    as.factor()

  return(ID)
}
