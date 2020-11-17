
#########################
### [ scrape  floor ] ###
#########################

# qui tira fuori i piani, la variabili tiene dentro anche 
# l'ascensore che forse è carino toglierlo, ma va bene farlo
# nel preprocessù
# 
# 
# ex. out:
# [1] "3° stabile, con ascensore"
# [1] "2° stabile, con ascensore"
# 

scrapefloor.imm = function(session){
  
  
  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  if ("piano" %in% web) {
    pos = match("piano",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}   
