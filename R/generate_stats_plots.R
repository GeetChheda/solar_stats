#' @name generate_stats_plots
#' @title Generate 
#' @author Geet Chheda, Sagar Shenoy, Animesh Chaturvedi, Ishwari Joshi, Shikhar Singh
#' @description
#' The function takes in input about the solar power data with the parameters of interest being
#' solar power output, the time frame for which the data was collected, temperature, pressure,
#' wind speed, wind direction. With this data we can either view the statistical process control
# of the power variation with time or understand the impact of a variable on power. 
#' 
#' @param file_path [.csv] Add a .csv file for your function to read 
#' @param x_var [character] Input column name of the independent variable - 
#' If using statistical process control with time (date_time) has to be the input variable 
#' with a start format of YYYY-MM-DD H:M:SS 
#' If understanding the impact then just use the column name 
#' @param y_var [character] Output column which will always be power in most cases
#' @param spec [numeric] The specification limit i.e. the minimum power required for the local area
#' @param x_label [character] label of x-axis for the plot to be generated
#' @param y_label [character] label of y-axis for the plot to be generated
#' @param plot_title [character] title for the plot to be generated

#' @note You can specify default inputs for an input parameter like with `type = "series"` below.
#' @import dplyr
#' @import readr
#' @import ggplot2
#' @import broom
#' @import lubridate
#' @export


generate_stats_plot <- function(file_path, x_var, y_var, spec, x_label, y_label, plot_title) {

  # Check for missing arguments
  missing_args <- missing(file_path) | missing(x_var) | missing(y_var) | missing(spec) | missing(x_label) | missing(y_label) | missing(plot_title)
    
    # If any input is missing, throw an error message
  if (missing_args) {
      stop("Error: Missing input(s). All arguments (a, b, c) must be provided.")}
  
  # Load data using the filename 
  solar <- read_csv(file = file_path)
  
  # Check if the columns x_var and y_var exist in the dataset
  if (!(x_var %in% colnames(solar)) || !(y_var %in% colnames(solar))) {
    stop("Specified columns not found in the dataset.")
  }
  
  # Select just needed variables ############################################################
  if (x_var == "date_time"){
    solar <- solar %>%
      select("date_time", y = y_var)
    
  }
  
  else{
    solar <- solar %>%
      select("date_time", x = x_var, y = y_var)
  }
  
  # Modifying data to convert data into standard weeks format ###############################
  solar <- solar %>%
    mutate(week = interval(start = date_time[1], end = date_time),
           week = as.numeric(week) / (60 * 60 * 24 * 7),
           week = ceiling(week)) %>%
    filter(week > 0)
  
  # Labels for graphs
  
  if(x_var == "date_time"){
    
    # Calculating within-group & between-group statistics ############################### 
    # Calculating mean, standard deviation, range, sigma_short, std error, confidence intervals #### 
    
    # Calculate within-group estimates
    stat_s = solar %>%
      group_by(week) %>%
      summarize(xbar = mean(y),
                sd = sd(y),
                r = max(y) - min(y),
                nw = n(),
                df = nw - 1) %>%
      # Calculate sigma_short (within-group variance)
      mutate(
        sigma_s = sqrt(mean(sd^2)), 
        # Get standard error
        se = sigma_s / sqrt(nw),
        # Calculate control limits!
        upper = mean(xbar) + 3*se,
        lower = mean(xbar) - 3*se
      )
    
    # Calculate between-group estimates
    stat_t <- stat_s %>%
      summarize(
        xbbar = mean(xbar),
        sigma_s = sqrt(mean(sd^2)),
        sigma_t = sd(solar$y),
        # Values for later use
        upper = unique(upper),
        lower = unique(lower),
        n = sum(nw),
        nw = unique(nw),
        k = n()
      )
    
    labels_xbbar <- data.frame(
      time = max(stat_s$week),
      type = "xbbar",
      name = "mean",
      value = round(mean(stat_s$xbar), 2),
      text = paste("mean =", round(mean(stat_s$xbar), 2))
    )
    
    labels_upper <- data.frame(
      time = max(stat_s$week),
      type = "upper",
      name = "+3σ",
      value = round(stat_s$upper[1], 2),
      text = paste("+3σ =", round(stat_s$upper[1], 2))
    )
    
    labels_lower <- data.frame(
      time = max(stat_s$week),
      type = "lower",
      name = "-3σ",
      value = round(stat_s$lower[1], 2),
      text = paste("-3σ =", round(stat_s$lower[1], 2))
    )
    
    labels <- rbind(labels_xbbar, labels_upper, labels_lower)
    
    gg1 <- ggplot(stat_s, aes(x = week, y = xbar)) +
      geom_ribbon(data = stat_s, mapping = aes(x = week, ymin = lower, ymax = upper),
                  alpha = 0.3, fill = "skyblue") +
      geom_line(size = 1, alpha = 1, color = 'royalblue') +
      geom_point(size = 2.5, alpha = 1, color = 'royalblue4') +
      geom_hline(mapping = aes(yintercept = mean(xbar)), linewidth = 1, color = 'blue4', linetype = "dotted") + 
      geom_hline(data = stat_s, aes(yintercept = spec), color = "blue3", alpha = 1) +
      geom_label(data = labels, mapping = aes(x = time, y = value, label = text),  hjust = 0.8)  +
      geom_label(aes(x = max(stat_s$week)-4, y = spec, label= "Specification Limit")) + 
      labs(x = x_label , y = y_label,
           title = paste(plot_title)) + 
      theme_light() + 
      theme(
        plot.title = element_text(hjust = 0.5),  # Centering the subtitle
        plot.margin = unit(c(3, 7, 3, 3), "mm")
      )
    gg1
    
    cpk = function(mu, sigma_s, lower = NULL, upper = NULL){
      if(!is.null(lower)){
        a = abs(mu - lower) / (3 * sigma_s)
      }
      if(!is.null(upper)){
        b = abs(upper - mu) /  (3 * sigma_s)
      }
      # If we got both stats, return the min!
      if(!is.null(lower) & !is.null(upper)){
        min(a,b) %>% return()
        
        # If we got just the upper stat, return b (for upper)
      }else if(is.null(lower)){ return(b) 
        
        # If we got just the lower stat, return a (for lower)
      }else if(is.null(upper)){ return(a) }
    }
    
    # Process Performance Index (for skewed, uncentered data)
    ppk = function(mu, sigma_t, lower = NULL, upper = NULL){
      if(!is.null(lower)){
        a = abs(mu - lower) / (3 * sigma_t)
      }
      if(!is.null(upper)){
        b = abs(upper - mu) /  (3 * sigma_t)
      }
      # We can also write if else statements like this
      # If we got both stats, return the min!
      if(!is.null(lower) & !is.null(upper)){
        min(a,b) %>% return()
        
        # If we got just the upper stat, return b (for upper)
      }else if(is.null(lower)){ return(b) 
        
        # If we got just the lower stat, return a (for lower)
      }else if(is.null(upper)){ return(a) }
    }
    
    estimate_Cpk = unique(cpk(mu = stat_t$xbbar, sigma_s = stat_t$sigma_s, upper = spec))
    
    estimate_Ppk = unique(ppk(mu = stat_t$xbbar, sigma_t = stat_t$sigma_t, upper = spec))
    
    # Return outputs
    list(
      stat_s = stat_s,
      stat_t = stat_t[1,],
      plot = gg1,
      Cpk = estimate_Cpk,
      Ppk = estimate_Ppk
    )
  }
  
  else{
    
    stat_s = solar %>% 
      group_by(week) %>% 
      summarize(mean_x = mean(x),
                xbar = mean(y)) 
    
    # Let's try it out!
    correlation_stats = stat_s %>%
      # convert to dataframe
      summarize(
        cor.test(x = mean_x, y = xbar) %>% tidy(),
        x = mean_x %>% quantile(probs = 0.99),
        y = xbar %>% quantile(probs = 0.95)
      ) %>%
      mutate(label = paste0("r = ", round(estimate, 3) ))
    
    gg1 <- ggplot(stat_s, aes(x = mean_x, y = xbar)) +
      geom_point(size = 3, shape = 21, alpha = 1, fill = 'white',color = 'royalblue4') +
      geom_smooth(se = FALSE) + # se = FALSE removes extra stuff
      geom_label(data = correlation_stats, 
                 mapping = aes(x = x, y = y, label = label),
                 hjust = 1,
                 size = 5) +
      labs(x = x_label , y = y_label,
           title = paste(plot_title)) + 
      theme_light() + 
      theme(
        plot.title = element_text(hjust = 0.5),  # Centering the subtitle
        plot.margin = unit(c(3, 7, 3, 3), "mm")
      )
    gg1
    
    # Return outputs
    list(
      stat_s = stat_s,
      model_stats = correlation_stats,
      plot = gg1
      #plot2 = mdat
    )
  }
}