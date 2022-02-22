#' @name createNftTimeSeriesPlot
#'
#' @title Plot a NFT Time Series Graph
#' 
#' @description This function takes a time series dataset and conducts the
#'   following using helper function in directory functions/helper_functions:
#'     1. Check data for errors
#'     2. Ensure date column is a date datatype
#'     3. Fill missing dates with the value 0
#'     4. Fill outcome values that equal zero with previous date value
#'     5. Plot a time series dataframe
#'  that the following dataframe is plotted:
#'  
#'   Dataframe Input Format:
#'   +------------+----------------+----------------+
#'   | dateCol    | <outcomeCol_1> | <outcomeCol_2> |
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
#'   | 01-01-2020 | <outcomeCol_1> | 157   |
#'   | 01-02-2020 | <outcomeCol_1> | 230   |
#'   | 01-03-2020 | <outcomeCol_1> | 230   |
#'   | 01-04-2020 | <outcomeCol_1> | 312   |
#'   | 01-01-2020 | <outcomeCol_2> | 100   |
#'   | 01-02-2020 | <outcomeCol_2> | 200   |
#'   | 01-03-2020 | <outcomeCol_2> | 300   |
#'   | 01-04-2020 | <outcomeCol_2> | 400   |
#'   +------------+----------------+-------+
#' 
#' @param dataframe A time series dataframe consisting of dates and one or more
#'   value columns that are continuous.
#' @param dateCol <string> The name of your date column.
#' @param outcomeCols <string> or <list> The numeric outcome columns to plot.
#' @param nftName <string> The name of the NFT project in long-form title case.
#' @param title <string> The title presented at the top of your graph.
#' @param lowerQuantile <float>
#' @param upperQuantile <float>
#' @param imputeData <bool> If TRUE, then impute missing values with the
#'   value from the respective date minus 1. 
#' @param geomLine <bool> If TRUE then line plot, if FALSE then point plot
#'   (default is TRUE).
#' @param logScale <bool> Default is FALSE, but if set to TRUE the plotted
#'   values will become log scaled and title will reflect Log Scaled.
#' @param savePlotData <bool> Default is FALSE, but if set to TRUE the
#'   underlying plot data will be saved to directory data/plot_figures_data/.
#' 
#' @export
createNftTimeSeriesPlot <- function(
  dataframe,
  dateCol,
  outcomeCols,
  nftName,
  title,
  lowerQuantile=0.00,
  upperQuantile=1.00,
  imputeData=FALSE,
  geomLine=TRUE,
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
  
  for (colName in outcomeCols) {
    quantileDf <- as.data.frame(selectDf) %>%
      dplyr::filter(
        get(colName) >= quantile(get(colName), lowerQuantile, na.rm=TRUE),
        get(colName) <= quantile(get(colName), upperQuantile, na.rm=TRUE)
      )
  }
  
  if(imputeData == TRUE) {
    fillDf <- fillMissingDates(quantileDf)
    plotDf <- replaceMissingValuesWithLast(fillDf)
  } else {
    plotDf <- quantileDf
  }
  
  # prepare plot caption if quantile filtered
  if(lowerQuantile>0.00 | upperQuantile<1.00) {
    caption <- paste0(
      '*Data filtered to quantile range ',
      lowerQuantile,
      '-',
      upperQuantile,
      ' to prevent graph scale issues.'
      )
  } else {
    caption <- ''
  }
  
  # plot time series
  plotTimeSeries(
    dataframe=plotDf,
    nftName=nftName,
    title=title,
    caption=caption,
    geomLine=geomLine,
    logScale=logScale,
    savePlotData=savePlotData
  )
}
