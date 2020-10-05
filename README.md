Asynchronous API Scraping [Immobiliare.it](https://www.immobiliare.it/)
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
*date*: Last update: 05 ottobre, 2020

<br>

This **RESTful API** provides a way to scrape the public
[Immobiliare.it](https://www.immobiliare.it/) database of Real Estate
rental market. Plumber does not have in-built features to handle calls
to the endpoints **Asynchronously**, as a matter of fact this is handled
inside the `plumber.R` MAIN function by the `foreach` package. Default
options provides the Real Estate rental Milan zone, nonetheless it is
possible to specify the city, the number of webpages of interest and
also selling (instead of rental market). *A further recent improvement
lets you specify the macrozone as filters directly in the api (in
itinere)* . For the time being is possible to filter out through
immobiliare the macrozone and the provide the API the url.

API is built with the `Plumber` framework, moreover it is containerized
with Docker. *It will be hosted on AWS EC2 server/ GCP with scheduler. *
On top of that each day a scheduler runs scraping functions and *store
daily data on a DB that can be queried given credentials* (in itinere):

<br><br>

minimal reprex why `foreach` handles requests faster vs `furrr`
(`future` spin-off). On x axis the number of urls processed, on y axis
run time:

<p align="center">

<div class="figure">

<img src="img/run_timefurrr.png" alt="linear time big-O(n)" width="696" />

<p class="caption">

linear time big-O(n)

</p>

</div>

</p>

<p align="center">

<div class="figure">

<img src="img/run_timeforeach.png" alt="log time  big-O(log(n))" width="696" />

<p class="caption">

log time big-O(log(n))

</p>

</div>

</p>

## API Documentation:

  - Get FAST data, it covers 5 covariates: title, price, num of rooms,
    sqmeter, primarykey

<!-- end list -->

``` r
      GET */scrape

      @param city [chr string] the city you are interested in (e.g. "roma", "milano", "firenze"--> lowercase, without accent)
      @param npages [positive integer] number of pages to scrape, default = 10, min  = 2, max = 300
      @param type [chr string] "affitto" = rents, "vendita"  = sell 
      content-type: application/json 
```

  - Get all the links

<!-- end list -->

``` r
      GET */link

      @param city [chr string] the city you are interested to extract data (lowercase without accent)
      @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
      @param type [chr string] "affitto" = rents, "vendita"  = sell 
      @param .thesis [logical] data used for master thesis
      content-type: application/json 
```

  - Get the complete set of covariates (52) from each single links,
    takes a while

<!-- end list -->

``` r
      GET */complete

      @param city [chr string] the city you are interested to extract data (lowercase without accent)
      @param npages [positive integer] number of pages to scrape default = 10, min  = 2, max = 300
      @param type [chr string] "affitto" = rents, "vendita"  = sell 
      @param .thesis [logical] data used for master thesis
      content-type: application/json
            
```
