## [ completescrape ] ----
## It scrapes the complete set of information avail on each ad link
options(future.rng.onMisuse="ignore")

completescrape2 = function(links){
            tic()
            plan(multisession, workers = availableCores()) ## sviluppa strategia
            
            result = tibble(
                        id =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapehouse.ID(session = sesh)},NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        lat =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapelat.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        long =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapelong.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        location =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    take.address(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        condom =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapecondom.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        buildage =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeagebuild.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        
                        floor =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapefloor.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr()
                        
                        # indivsapt =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapetype.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # locali =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapecompart.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # tpprop =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeproptype.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # status =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapestatus.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # heating =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeheating.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # ac =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeaircondit.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # date =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeaddate.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # catastinfo =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapecatastinfo.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # aptchar =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeaptchar.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # photosnum =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapephotosnum.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # age =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeage.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # enclass =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeenclass.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # contr =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapecontr.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # disp =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapedisp.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # totpiani =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapetotpiani.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # postauto =  future_map(links, possibly(~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapepostauto.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # review =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapereareview.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # metrat =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapemetrature.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # multi =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapehasmulti.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # lowprice =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapeloweredprice.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # nrooms =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapenroomsINS.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # price =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapepriceINS.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # sqfeet =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapesqfeetINS.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr(),
                        # 
                        # title =  future_map(links, possibly( ~{
                        #             sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                        #             if (class(sesh)=="session") {sesh = sesh$response}
                        #             scrapetitleINS.imm(session = sesh) },NA_character_, quiet = FALSE))%>%  flatten_chr()
                        
                        
            )
            
            toc()
            return(result) 
            
}