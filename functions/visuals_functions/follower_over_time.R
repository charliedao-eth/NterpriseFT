#' Follower Count Over Time
#'
#' @name plot_followers
#' 
#' @title Plot Followers
#' 
#'@description Creates a plot of Twitter follower over time (daily level) with
#' option to log-scale the follower axis. Will warn upon class conversion and if 
#' column names are not found.
#' 
#' @param history Dataset expected from SocialBlade API Call 
#' @param datecol Date column, default `date`
#' @param followercol Follower column, default `followers`
#' 
#' @export
#' @examples 
#' history <- read.csv("data/bayc_history.csv", row.names = NULL)
#' plot_followers(history)
#' plot_followers(history, logscale = TRUE)

plot_followers <- function(history, datecol = "date",
                              followercol = "followers",
                              logscale = FALSE){ 
  
  if( !(datecol %in% colnames(history)) | 
      !(followercol %in% colnames(history)) ) { 
    stop("Expected column names not found in data.")
    }
  
  if( class(history[[datecol]]) != "Date" ){
    warning("Converting date column to class date")
    history[[datecol]] <- as.Date(history[[datecol]])
  }
  
  if(  !is.numeric(history[[followercol]]) ){ 
    warning("Converting follower column to class numeric")
    history[[followercol]] <- as.numeric(history[[followercol]])
    }
  
 g <- ggplot(history) +
    aes_string(x = datecol, y = followercol) +
    geom_line() + 
    xlab("") + 
   ylab("") + 
    theme_classic() +
   scale_x_date(date_labels = "%b-%Y")
 
 if(logscale == TRUE){ 
   g <- g + scale_y_log10()
   }
 
    ggplotly(g) %>% 
      config(displaylogo = FALSE, displayModeBar = TRUE) %>% 
    layout(title ="\n Twitter Followers over Time") 
  }
