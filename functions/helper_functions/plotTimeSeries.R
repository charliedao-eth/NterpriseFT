#' @name plotTimeSeries
#'
#' @title Plot a Time Series Graph
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
#'   values will become log scaled and title will reflect Log Scaled.
#' @param savePlotData <bool> Default is FALSE, but if set to TRUE the
#'   underlying plot data will be saved to directory data/plot_figures_data/.
#' 
#' @export
plotTimeSeries <- function(dataframe, title, logScale=FALSE, savePlotData=FALSE) {
  message(paste0('Plotting ', title, '...'))
  
  df <- as.data.frame(dataframe) %>%
    mutate(date = as.Date(date))
  
  timeSeriesPlotDf <- melt(df, id.vars = 'date')
  
  if(logScale == TRUE) {
    message('Log scaling plot data...')
    timeSeriesPlotDf$value <- log(timeSeriesPlotDf$value + 1)
    title <- paste0(title, ' Log Scaled')
  }
  
  if(savePlotData == TRUE) {
    filePath <- paste0('data/plot_figures_data/', title, '.csv')
    message(paste0('Saving underlying plot data to ', filePath))
    write.csv(timeSeriesPlotDf, filePath)
  }
  
  timeSeriesPlot <- ggplot(
    timeSeriesPlotDf,
    aes(x = date, y = value, color = variable)
  ) +
    geom_line() +
    xlab("") +
    scale_x_date(date_labels = "%m-%Y") +
    ggtitle(title)
  
  print(timeSeriesPlot)
}
