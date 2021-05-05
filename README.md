dogetweet
================
Ivan Cherniavskyi
2021-05-05

This package is creating data frame which includes information about
desired crypto currencies provided by
[CoinMarketCap](https://coinmarketcap.com/), as well as conversation
volume markers in various social media.

## Install

Install from GitHub with the following code:

``` r
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}
devtools::install_github("icherniavsky/dogetweet")
```

This package connects <code>dogetweet</code> to <code>rtweet</code>,
<code>gtrendsR</code>, <code>RedditExtractoR</code> and
<code>coinmarketcapr</code>.

As a result, each user must have previously acquired Basic API Key from
CoinMarketCap which can be found by following this
[link](https://coinmarketcap.com/api/).

Additionally, each user must have twitter account for
<code>rtweet</code> to work. At the first start of
<code>dogetweet</code>, <code>rtweet</code> will connect you to Twitter
API automatically in a new window of your browser. Be aware that the
function <code>stream\_tweets</code> has some restrictions. More
information about the restricitions can be found
[here](https://developer.twitter.com/en/docs/twitter-api/v1/tweets/filter-realtime/guides/streaming-message-types).

## Usage

There are three functions currently live for dogetweet.

To begin, the user must first enter the following code, inserting their
key:

``` setup
api_setup("YourAPIKey")
```

Currently, this must be done at the start of every session.

The next function <code>crypto\_names</code> is designed to provide the
user with all crypto currencies available for usage with
<code>dogetweet</code>.

``` cryoto_names
crypto_names(name = "crypto_list")

crypto_names(crypto_list)

Example of the crypto_list object:

[1] Bitcoin

[2] Euthereum

[3] Binance Coin

[4] XRP

[5] Tether
```

<code>crypto\_names</code> has one argument which assigns the chosen
name to the object with the list of currencies. The default name of the
object is crypto\_list.

The third and main function is <code>dogetweet</code>. It gathers data
from CoinMarketCap and three media platforms like Twitter, Reddit and
Google Hits. The function put the collected data into a data frame in
the global environment. Additionally, it saves data frame into user’s
working directory as .RData file. The name of data frame/object and
.RData file is the same as the name of searched crypto currency.

``` dogetweet
dogetweet(crypto = "Dogecoin", timout = 60)
```

The <code>dogetweet</code> function itself has two arguments.

The first argument is the name of crypto currency to perform search for.
The default is Dogecoin.

The next argument determines how long an open stream of tweets will be
collected, with a default of 60 seconds. Please be aware that
<code>rtweet</code> has several restriction. It is not recommended to
run the function more than 1 time per minute or run two searches
simultaneously. More information can be found
[here](https://developer.twitter.com/en/docs/twitter-api/v1/tweets/filter-realtime/guides/streaming-message-types).

![](https://github.com/icherniavsky/dogetweet/blob/master/data_frame_example/dogecoin_data_example.PNG)

The data frame has 12 variables. Name variable is the name of the
selected crypto currency. USD\_last\_updated is the time when the price
of the currency was updated by CoinMarketCap. Sys\_time and Sys\_date
are time and date when the function was run by the user. USD\_price is
the current price of the currency. Price\_change describes the rate of
change of the price. Tweets is the number of tweets found by streaming.
Twitter\_change is the rate of change in number of tweets. Google\_hits
is the number of hits in Google regarding the currency. Google\_change
describes the rate of change in hits. Reddit\_comments shows the number
of comments in Reddit regarding crypto. And reddit\_change describes the
rate of change of Reddit comments.

This process takes some time, as dogetweet relies on multiple
dependencies such as Rtweet, RedditExtractoR and gtrendsR which take
some time to run.
