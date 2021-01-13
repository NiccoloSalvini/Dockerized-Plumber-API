####################################
### [ scrape real estate descr ] ###
####################################
#
# ex. out:
# [1] "Rif: quadrilatero - QUADRILATERO DELLA MODA - VIA BORGOSPESSO, \nIn piccolo immobile 
# del 1700 vincolato dalle Soprintendenza e completamente ristrutturato, splendido appartamento
# al terzo piano di mq. 160 oltre a due terrazzi di mq. 60, composto da ingresso, salone, sala 
# da pranzo, due camere con due bagni, e zona di servizio composta da ingresso, cucina, office,
# camera e bagno. Doppia esposizione sul cortile e su Via Borgospesso, riscaldamento e acqua
# calda centralizzati, predisposizione per l’aria condizionata, porte blindate, parquet, varie
# armadiature, librerie e boiseries, ristrutturato. Portineria e due ascensori. \nCanone annuo 
# di € 89.000,00= oltre alle spese di € 15.000,00= salvo conguaglio.\nDisponibilità in cortile
# di posto auto coperto semimeccanizzato a € 10.000,00=.\nPER INFORMAZIONI ELENA BASSOLI 
# 3381615454 GIOVANNA COMPARE 3495022506 p. s. www.elenabassolirealestate.it Le metrature degli
# immobili sono del tutto indicative e non potranno essere utilizzate come parte integrante in
# un eventuale contratto di vendita o locazione della proprietà. Lo STUDIO IMMOBILIARE ELENA BASSOLI
# non accetta responsabilità di qualsiasi genere collegata alle informazioni riportate, in
# quanto tutto il materiale e la documentazione in possesso dell’agenzia, si basa su dati 
# forniti da terze persone. Queste informazioni vengono considerate veritiere e quindi si 
# declina ogni responsabilità circa omissioni, inesattezze ed attualità delle stesse. Su alcuni 
# immobili Le foto potrebbero non corrispondere all'originale per privacy richiesta dalla proprietà
# .\"\nIl compenso (provvigione), maggiorato dell'IVA secondo l'aliquota di legge, ammonta al 3% del
# prezzo di vendita dell'immobile, al 15% del canone di locazione annuo (o del totale del periodo temporaneo
# di locazione). Il diritto alla provvigione matura, in caso di compravendita, nel momento in cui l'Acquirente
# viene a conoscenza dell'accettazione della sua proposta da parte del venditore, o alla firma del contratto 
# di locazione."



scrapereareview.imm = function(session){

  
  review = read_html(session) %>%
    html_nodes(css ='.js-readAllText') %>%
    html_text() %>%
    str_trim()
  
  return(review)
}   

