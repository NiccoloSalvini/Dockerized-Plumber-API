# here I take the date it allegedly was built
# estimation are not really accurate,
# data here do not rely on historical info
# coming from authentic municipality's archive
# (many NAs)
# 
# ex out: (numeric NOT Date class)
# 1700
# 1920

scrapeagebuild.imm = function(session) {
  
  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>% 
    html_text() %>%
    str_trim() 
  
  if ("anno di costruzione" %in% web) {
    pos = match("anno di costruzione",web)
    web[pos+1] %>%
      return()
    # as.numeric()
    } else {
     return(NA_character_)
      
      }
}

