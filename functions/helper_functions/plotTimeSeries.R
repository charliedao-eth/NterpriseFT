#' @name plotTimeSeries
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
plotTimeSeries <- function(dataframe, title, logScale=FALSE) {
  df <- as.data.frame(dataframe)
  timeSeriesPlotDf <- melt(df, id.vars = 'date')
  
  if(logScale == TRUE) {
    timeSeriesPlotDf$value <- log(timeSeriesPlotDf$value + 1)
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
