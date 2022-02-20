#' @name createNftTimeSeriesPlot
#'
#' @title Replace Missing Values with Last
#' 
#' @description This function takes a time series dataset and "melts" it so
#'  that the following dataframe is plotted:
#'  
#'   Dataframe Input Format:
#'   +------------+----------------+----------------+
#'   | date       | <your_value_1> | <your_value_2> |
#'   +------------+----------------+----------------+
#'   | 01-01-2020 | 157            | 100            |
#'   | 01-02-2020 | 230            | 200            |
#'   | 01-03-2020 | 230            | 300            |
#'   | 01-04-2020 | 312            | 400            |
#'   +------------+----------------+----------------+
#'   
#'   Dataframe to be Plotted:
#'   +------------+----------------+-------+
#'   | date       | variable       | value |
#'   +------------+----------------+-------+
#'   | 01-01-2020 | <your_value_1> | 157   |
#'   | 01-02-2020 | <your_value_1> | 230   |
#'   | 01-03-2020 | <your_value_1> | 230   |
#'   | 01-04-2020 | <your_value_1> | 312   |
#'   | 01-01-2020 | <your_value_2> | 100   |
#'   | 01-02-2020 | <your_value_2> | 200   |
#'   | 01-03-2020 | <your_value_2> | 300   |
#'   | 01-04-2020 | <your_value_2> | 400   |
#'   +------------+----------------+-------+
#'   
#'   Dataframe MUST include a column named "date", and one or more value columns
#'   that are continuous.
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' @param title <string> The title presented at the top of your graph.
#' @param logScale <bool> Default is FALSE, but if set to TRUE the plotted
#'   values will become log scaled.
#' 
#' @export
createNftTimeSeriesPlot <- function(
  dataframe,
  dateCol,
  outcomeCols,
  nftName,
  title,
  logScale=FALSE,
  savePlotData=FALSE
  ) {
  df <- as.data.frame(dataframe)
  
  # data checks
  for (colName in c(dateCol, outcomeCols)) {
    if(!(colName %in% colnames(df))) { 
      stop(paste0('Expected ', colName, ' column not found in dataframe.'))
    }
  }
  
  for (colName in outcomeCols) {
    if(!is.numeric(df[[colName]])) { 
      warning(paste0('Converting ', colName, ' column to class numeric...'))
      df[[colName]] <- as.numeric(df[[colName]])
    }
  }
  
  # prepare plot title
  plotTitle <- paste0(nftName, ' ', title)
  message(paste0('Preparing ', plotTitle, '...'))
  
  # prepare dataframe
  names(df)[names(df) == dateCol] <- 'date'
  selectCols <- c('date', outcomeCols)
  selectDf <- df %>%
    mutate(date = as.Date(date)) %>%
    select(selectCols)
  fillDf <- fillMissingDates(selectDf)
  replaceDf <- replaceMissingValuesWithLast(fillDf)
  
  # plot time series
  plotTimeSeries(
    dataframe=replaceDf,
    title=plotTitle,
    logScale=logScale,
    savePlotData=savePlotData
  )
}
