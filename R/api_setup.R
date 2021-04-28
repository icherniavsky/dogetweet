#' api_setup
#' 
#' This function connect the user's API key to the CoinMarketCap.
#'
#' @author Ivan Cherniavskyi
#'
#' @param API is the API Key input that user paste as a string.
#'
#' @return Connects the user to the CoinMarketCap base.
#'
#' @examples
#' 
#' api_setup("Your_API_here")
#' 
#' @export

api_setup = function(API){
  
# connect the user's api to the CoinMarketAPR
  
  coinmarketcapr::setup(API) 
  
}