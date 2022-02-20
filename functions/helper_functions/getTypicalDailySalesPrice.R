#' @name getTypicalDailySalesPrice
#'
#' @title Get Typical Daily Sales Price
#' 
#' @description This function take a dataframe, date column, and price column
#'   and determines a date's min, max, median price values.
#'   
#'   Dataframe Input Format:
#'   +------------+--------------+
#'   | dateCol    | priceCol     |
#'   +------------+--------------+
#'   | 01-01-2020 | 100          |
#'   | 01-01-2020 | 200          |
#'   | 01-01-2020 | 300          |
#'   | 01-02-2020 | 150          |
#'   | 01-02-2020 | 250          |
#'   | 01-02-2020 | 350          |
#'   +------------+--------------+
#'   
#'   Dataframe Output Format:
#'   +------------+-----------+-----------+--------------+
#'   | dateCol    | min_price | max_price | median_price |
#'   +------------+-----------+-----------+--------------+
#'   | 01-01-2020 | 100       | 300       | 200          |
#'   | 01-02-2020 | 150       | 350       | 250          |
#'   +------------+-----------+-----------+--------------+
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' @param dateCol <string>
#' @param priceCol <string>
#' 
#' @import dplyr
#' 
#' @export
getTypicalDailySalesPrice <- function(dataframe, dateCol, priceCol) {
  message('Preparing typical sales price data aggregates...')
  df <- as.data.frame(dataframe)
  
  # data checks
  for (colName in c(dateCol, priceCol)) {
    if(!(colName %in% colnames(df))) { 
      stop(paste0('Expected ', colName, ' column not found in dataframe.'))
    }
  }
  
  for (colName in priceCol) {
    if(!is.numeric(df[[colName]])) { 
      warning(paste0('Converting ', colName, ' column to class numeric...'))
      df[[colName]] <- as.numeric(df[[colName]])
    }
  }
  
  # prepare dataframe
  names(df)[names(df) == dateCol] <- 'date'
  typicalSalesDf <- df %>%
    mutate(date = as.Date(date)) %>%
    select(c('date', priceCol)) %>%
    group_by(date) %>%
    summarise(
      min_price = round(min(PRICE), 2),
      max_price = round(max(PRICE), 2),
      median_price = round(median(PRICE), 2)
    )
  
  return(typicalSalesDf)
}
