#' dogetweet
#' 
#' The function creates  data frame and .RData in the working directory 
#' file with information regarding selected crypto currency. 
#'
#' The function creates data frame with 12 variables which include the name of
#' the selected crypto currency, its price and time of the last update by 
#' CoinMarketCap. Additionally, the data frame includes the conversation volume 
#' markers in various social media, such as Twitter, Google Hits and Reddit. 
#' The function also calculates the rate of change in conversation volume and 
#' price variables. 
#'
#' @author Ivan Cherniavskyi
#'
#' @param crypto A crypto currency the user wants to gather information about.
#' Default is Dogecoin. 
#' 
#' @param timeout Amount of time how long an open stream of tweets will be 
#' collected. Default is 60 seconds.
#' 
#' @return Creates a date frame and .RData file in working directory with 
#' information about selected crypto currency.
#'
#' @examples
#' 
#' dogetweet(crypto = "Bitcoin", timeout = 60)
#' 
#' dogetweet(crypto = "Dogecoin", timeout = 15)
#' 
#' @export

dogetweet = function(crypto = "Dogecoin", timeout = 60){
  
  # Create if else statement 
  
  if(file.exists(paste0(crypto, ".RData"))){
    
    # attach a new outcome to existed data frame 
    
    load(paste0(crypto, ".RData"))} else {
      
      # create a new data frame if its first run
      
      results = data.frame()
    }
  
  # Obtain the information about all currencies in the CoinMarketCap
  
  all_crypto <- coinmarketcapr::get_crypto_listings()
  
  # Obtain the data from Twiiter about selected currency
  
  tweets_volume = rtweet::stream_tweets(crypto, timeout = timeout)
  
  # Obtain the data from Google Hits about selected currency
  
  google_info = gtrendsR::gtrends(crypto, time = "now 1-d")
  
  # create a new object for google data
  
  google_set = google_info[[1]] %>% 
    
    # group the data by key word 
    
    dplyr::group_by(keyword) %>% 
    
    # get the number of hits by summarizing them 
    
    dplyr::summarise(google_hits = sum(hits))
  
  # get the data from Reddit
  
  reddit_info = RedditExtractoR::reddit_urls(crypto) %>% 
    
    # get the number of comments by summarizing them 
    
    dplyr::mutate(reddit_comments = sum(num_comments)) %>%
    
    # get the first row of Reddit data
    
    dplyr::slice(1)
  
  # get the current date and time 
  
  system_time_date = data_frame(sys_time_date = Sys.time())
  
  # create a new object
  
  time_and_date = system_time_date %>% 
    
   # separate the date and time 
    
     tidyr::separate(sys_time_date, into = c("sys_date", "sys_time"), 
                    
                    sep = " ", remove = FALSE)
  
  # create a for loop for each crypto currency
  
  for(coin in crypto){
    
   # create an object to bind the data
    
     currency_output = all_crypto %>% 
      
      # Import the name, price and the last update date from all_crypto object.
       
      dplyr::select(name, USD_price, USD_last_updated) %>% 
      
      # Find the selected crypto currency in tweets_volume object
       
      dplyr::filter(str_detect(name, crypto)) %>% 
      
      # Create a new column in currency_output regarding google hits
       
      add_column("google_hits" = google_set$google_hits) %>%
      
      # Add the number of hits.
       
      dplyr::filter(row_number() == 1)
    
    # Add the time and date
    
    currency_output = dplyr::bind_cols(currency_output, time_and_date) 
    
    # Create if else statement for tweets
    
    if(is.null(tweets_volume) == TRUE){
      
      # create a data frame with 0 value for tweets
      
      tweets_volume = data_frame(tweets = 0)
      
      # bind the value to currency_output object
      
      currency_output = dplyr::bind_cols(currency_output, tweets_volume)
      
    }else{
      
     # add the number of tweets to currency_output if they were found
      
      currency_output = dplyr::mutate(currency_output, 
                                      
                                      "tweets" = nrow(tweets_volume))
      
    }
    
    # Create if else statement for reddit comments
    
    if(is.null(reddit_info) == TRUE){
      
      # create a new data frame with value of comments = 0 if they weren't found
      
      reddit_info = data_frame(reddit_comments = 0)
      
      # bind the 0 value data frame to currency_output object
      
      currency_output = dplyr::bind_cols(currency_output, reddit_info)
      
    }else{
      
      # add the number of comment to currency_output if they were found
      
      currency_output = add_column(currency_output, 
                                   
                                   "reddit_comments" = reddit_info$reddit_comments)
      
    }
    
    #add the rows of currency_output object to the new data frame
    
    results = dplyr::bind_rows(results, currency_output)
    
  }
  
  # add rate of change to the results object
  
  results = results %>% 
    
    # calculate rate of change to the price variable
    
    dplyr::mutate(price_change = (USD_price/lag(USD_price) - 1) * 100) %>%
    
    # calculate rate of change to the number of tweets variable
    
    dplyr::mutate(twitter_change = (tweets/lag(tweets) - 1) * 100) %>%
    
    # calculate rate of change to the number of google hits variable
    
    dplyr::mutate(google_change = (google_hits/lag(google_hits) - 1) * 100) %>%
    
    # calculate rate of change to the number of reddit comments variable
    
    dplyr::mutate(reddit_change = (reddit_comments/lag(reddit_comments) - 1) * 100)
  
  
  # order the variables into practical order
  
  results = results[, c("name", "USD_last_updated", "sys_date", "sys_time", 
                        
                        "USD_price", "price_change","tweets", "twitter_change", 
                        
                        "google_hits", "google_change", "reddit_comments", 
                        
                        "reddit_change")]
  
  # change NA values to 0s
  
  results[is.na(results)] <- 0
  
  # save the gathered data to the Rdata file
  
  save(results, file = paste0(crypto, ".RData"))
  
  # assign the name of the crypto currency to the new data frame
  
  assign(crypto, value = results, envir = globalenv())
  
  # put a message about complition of the function 
  
  message(crypto, " was updated.")
}
