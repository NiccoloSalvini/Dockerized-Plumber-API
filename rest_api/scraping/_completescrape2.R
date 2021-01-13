## [ completescrape ] ----
## It scrapes the complete set of information avail on each ad link
options(future.rng.onMisuse="ignore")

## valutare di cercare nel json, dovrebbe essere infintamente più veloce

completescrape2 = function(links){
            
            tic()
            result = tibble(
                        id =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapehouse.ID(session = sesh)},NA_character_, quiet = FALSE)),
                        
                        lat =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapelat.imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        long =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapelong.imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        location =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    take.address(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        condom =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapecondom.imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        buildage =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeagebuild.imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        floor =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapefloor.imm(session = sesh) },NA_character_, quiet = FALSE)),
                        
                        indivsapt =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapetype.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        locali =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapecompart.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        tpprop =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeproptype.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        status =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapestatus.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        heating =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeheating.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        ac =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeaircondit.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        date =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeaddate.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        catastinfo =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapecatastinfo.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        aptchar =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeaptchar.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        photosnum =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapephotosnum.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        age =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeage.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        enclass =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeenclass.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        contr =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapecontr.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        disp =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapedisp.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        totpiani =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapetotpiani.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        postauto =  future_map(links, possibly(~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapepostauto.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        review =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapereareview.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        metrat =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapemetrature.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        multi =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapehasmulti.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        lowprice =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapeloweredprice.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        nrooms =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapenroomsINS.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        price =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapepriceINS.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        sqfeet =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapesqfeetINS.imm(session = sesh) },NA_character_, quiet = FALSE)),

                        title =  future_map(links, possibly( ~{
                                    sesh = html_session(.x, user_agent(agent = agents[sample(1)]))
                                    if (class(sesh)=="session") {sesh = sesh$response}
                                    scrapetitleINS.imm(session = sesh) },NA_character_, quiet = FALSE))

                        
            )
            
            toc()
            return(result %>%  unnest(cols = c(id, lat, long, location, condom, buildage, floor, indivsapt, 
                                               locali, tpprop, status, heating, ac, date, catastinfo, aptchar, 
                                               photosnum, age, enclass, contr, disp, totpiani, postauto, 
                                               review, metrat, multi, lowprice, nrooms, price, sqfeet, title))) 
            
}
