#' crypto_names
#' 
#' This function creates an object with all the names of crypto currencies 
#' can be searched by dogetweet().
#'
#' @author Ivan Cherniavskyi
#'
#' @param name A paremetr that assign name to the object in the environment.  
#'
#' @return a data frame with all the crypto currencies witch can be searched 
#' by dogetweet() function. Default name of the object is crypto_list
#'
#' @examples
#' 
#' crypto_names(x)
#' 
#' crypto_names(new_object)
#' 
#' @export

crypto_names = function(name = "crypto_list"){
  
  # create an object with the data from the CoinMarketcAPR
  
  coin_market <-  coinmarketcapr::get_crypto_listings()
  
  # create a new object
  
  crypto_names <- coin_market %>% 
    
  # select the names of the crypto currencies
    
    dplyr::select(name)
  
  # assign the chosen name to the new object
  
  assign(name, value = crypto_names, envir = globalenv())
}