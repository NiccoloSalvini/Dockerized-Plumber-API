Dockerized API Scraping [Immobiliare.it](https://www.immobiliare.it/)
================

  - [API Infrastructure](#api-infrastructure)
  - [API Documentation:](#api-documentation)

<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="img/logo.png" align="right" height="80" />

## API Infrastructure

*author*: **[Niccolò Salvini](https://niccolosalvini.netlify.app/)**
*date*: 04 settembre, 2020

<br>

These **REST APIs** provide a way for platform/language independent
access to the public [Immobiliare.it](https://www.immobiliare.it/)
dataset of real estate rental market. The dataset is going to be updated
daily, some of the entries can be deleted and replaced by some other. In
order to keep track to changes in the dataset I strongly suggest to
store the daily meausuraments and then merge them through a scheduler
(lately I am thinking on doing it). The `plumber.R` has two main
functions scrape.all, scrape.all.info. Final Information come from two
different scrapping functions due to speed up processes. The former
gathers data from the grouping url, where the website displays 25 rental
ads at the same time, data available is reatricted to 5 covariates. The
latter gathers all the rest and it goes deep in single rental house
advertisement. It is easy to grasp that scrapping from the agglomerative
link, from now on category link, requests a single session, meanwhile
the other investigate one single link at a time. Data comes in a
**JSON** fromat. Parameters let you set the *url* from which you want to
extract information and the number of pages, *npages*, that you may want
to scrap .<br><br>

<p align="center">

<img src="img/apiinfr.PNG" width="1200" />

</p>

## API Documentation:

  - Get fast raw data, 5 covariates: title, price, num of rooms,
    sqmeter, primarykey
    
        GET */scrape
        
        param url the category link from which you are interested to extract data
        param npages number of pages that are going to be scraped
        content-type: application/json 

  - Get all the links
    
        GET */link
        
        param url the category link from which you are interested to extract data
        param npages  num of pages you are interested in
        content-type: application/json
