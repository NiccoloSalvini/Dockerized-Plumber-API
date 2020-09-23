Dockerized API Scraping [Immobiliare.it](https://www.immobiliare.it/)
================

  - [API Infrastructure](#api-infrastructure)
  - [API Documentation:](#api-documentation)

<!-- README.md is generated from README.Rmd. Please edit that file -->

x

<img src="img/logo.png" align="right" height="80" />

## API Infrastructure

[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity)
<a href="https://www.buymeacoffee.com/gbraad" target="_blank"><img src="img/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a>

*author*: **[Niccolò Salvini](https://niccolosalvini.netlify.app/)**
*date*: 23 settembre, 2020

<br>

This **REST API** provides a way for platform/language independent
access to the public [Immobiliare.it](https://www.immobiliare.it/)
database of Real Estate rental market. By default it provides to the
scraping functions the corresponding Milan url connected to its Real
Estate market, it will be possible for sure to provide only the city
information in the very next future. It can be extended also for other
cities by providing different urls. API are built with `Plumber`. They
are containerized in a Docker container which will be hosted on AWS EC2
server. On top of that each day a scheduler runs scraping functions and
*store daily data on a DB that can be queried given credentials* (in
itinere): <br><br>

<p align="center">

<img src="img/dpapi.png" width="562" />

</p>

## API Documentation:

  - Get FAST data, it covers 5 covariates: title, price, num of rooms,
    sqmeter, primarykey

<!-- end list -->

``` r
      GET */scrape

      param url [url string] the link from which you are interested to extract data 
      param npages [positive integer] number of pages to scrape (1-300) 
      content-type: application/json 
```

  - Get all the links

<!-- end list -->

``` r
      GET */link

      param url [url string]  the link from which you are interested to extract data
      param npages  [positive integer] number of pages to scrape (1-300) 
      content-type: application/json 
```

  - Get the complete set of covariates (52) from each single links,
    takes a while

<!-- end list -->

``` r
      GET */complete

      param url  _url string_ url the link from which you are interested to extract data
      param npages [positive integer] number of pages to scrape (1-300) 
      content-type: application/json
            
```
