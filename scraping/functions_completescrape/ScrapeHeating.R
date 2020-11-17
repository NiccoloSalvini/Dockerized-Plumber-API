# qui prendo il riscaldamento 
# 
# ex out:
# "Autonomo, a radiatori, alimentato a metano"
# "Autonomo"
# "Centralizzato, a radiatori, alimentato a metano"
# "Centralizzato, a radiatori, alimentato a gas"

scrapeheating.imm = function(session) {

  web = read_html(session) %>%
    html_nodes(css ='.im-features__value , .im-features__title') %>%
    html_text() %>%
    str_trim()
  
  if ("riscaldamento" %in% web) {
    pos = match("riscaldamento",web)
    return(web[pos+1])
  } else {
    return(NA_character_)
  }
  
}
