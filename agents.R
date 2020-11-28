## get_latest user agents
## source = https://user-agents.net/ 
## 

url = "https://user-agents.net/"
agents = read_html(url) %>% html_nodes(css = ".agents_list li") %>% html_text()
