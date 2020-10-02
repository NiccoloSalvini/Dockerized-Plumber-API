## [ all.links ] ----
## it extracts all the links, which are the single house ad
## inside a single agglomerative url

all.links= function(url  = "https://www.immobiliare.it/affitto-case/milano/?criterio=rilevanza&localiMinimo=1&localiMassimo=5&idMZona[]=10046&idMZona[]=10047&idMZona[]=10053&idMZona[]=10054&idMZona[]=10057&idMZona[]=10059&idMZona[]=10050&idMZona[]=10049&idMZona[]=10056&idMZona[]=10055&idMZona[]=10061&idMZona[]=10060&idMZona[]=10070&idMZona[]=10318&idMZona[]=10296&idMZona[]=10069",
                    npages = 10) {
            cl = makeCluster(detectCores()-1) #using max cores - 1 for parallel processing
            registerDoParallel(cl)
            
            ## build the url array 
            list.of.pages.imm = str_c(url, '&pag=', 2:npages) %>% 
                        append(url, after = 0)
            
            listone = foreach(i = seq_along(list.of.pages.imm),
                              .packages = vec.pacchetti,
                              .combine = "c",
                              .multicombine = TRUE,
                              .verbose = FALSE,
                              .errorhandling='pass') %dopar% {
                                          ## Utils start----
                                          
                                          
                                          agents =  c('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.116 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/602.2.14 (KHTML, like Gecko) Version/10.0.1 Safari/602.2.14',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.98 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.99 Safari/537.36',
                                                      'Mozilla/5.0 (Windows NT 10.0; WOW64; rv:50.0) Gecko/20100101 Firefox/50.0')
                                          
                                          
                                          ## [ add other Headers ] ----
                                          
                                          
                                          mails = c('heurtee@triderprez.cf',
                                                    'nonliqui@famalsa.tk',
                                                    'bemerker@vagenland.gq',
                                                    'deutoplasm@c032bjik.buzz',
                                                    'controllably@mirider.ga')
                                          
                                          
                                          len = function(x){
                                                      length(x) %>% 
                                                                  print()
                                          }  
                                          
                                          ## [ sleep fucntion to simulate request delay  ] ----
                                          
                                          dormi = function() {
                                                      Sys.sleep(sample(seq(1, 2, by=0.001), 1))
                                          }
                                          
                                          ##  end utils ----
                                          
                                          ## [ scrapehref.imm MOD] ----
                                          
                                          scrapehref.imm = function(url){
                                                      
                                                      session = html_session(url,user_agent(agent = agents[sample(1)]))
                                                      
                                                      web = read_html(session) %>% 
                                                                  html_nodes(css = '.text-primary a') %>% 
                                                                  html_attr('href') %>%
                                                                  as.character()
                                                      return(web)
                                          }
                                          
                                          x = scrapehref.imm(list.of.pages.imm[i]) 
                              }
            stopCluster(cl)
            return(listone)
}