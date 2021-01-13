# Here I extract the type of contract that the tenant countrerpart wants 
# 
# ex. out: 
# "Affitto" 
# 
# (since the main URL is filtered for "Affitto" 
#  we are not going to observe anything differnent
#  from the "Affitto" cat) 

scrapecontr.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim()
  
  
  if ("contratto" %in% web) {
    pos = match("contratto",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}
