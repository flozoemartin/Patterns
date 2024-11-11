################################################################################

# Distinguishing types of users during pregnancy and types of discontinuers prior to pregnancy

# Author: Flo Martin

# Date: 17/10/2022

################################################################################

# Figure S1 - Type of antidepressant use before and during pregnancy.

################################################################################

# Load in the package we're using & set working directory

    install.packages("ggplot2")
    install.packages("ggtext")
    
    library(ggplot2)
    library(ggtext)
    
    setwd("//ads.bris.ac.uk/filestore/HealthSci SafeHaven/CPRD Projects UOB/Projects/21_000362/Flo/6_graphfiles/1_patterns of prescribing")

# Create the dataset used by ggplot to make the figure - pattern (y) describes the exposures groups (prevalent exposed 4, incident exposed 3, indicated unexposed 2 and non-indicated unexposed 1) and timing of exposure (x) describes when the prescription may or may not occur in order to define exposure groups. y will be the same for each timing to achieve the straight, timeline effect in this particular figure

# Make the dataframe

    pattern <- c(0,0,0,1,1,1,2,2,2,4,4,4,5,5,5)   

# y axis - note 0,1,2 followed by 4,5,6 giving a bigger gap on the y axis between exposed and unexposed (for ease of reading)

    timing <- c(1,2,3,1,2,3,1,2,3,1,2,3,1,2,3)   

# x axis

    data <- data.frame(pattern,timing)

# Make the figure

    ggplot(data, aes(x=timing)) +   
  
  # gives axes on which the graph can be drawn (don't to add points yet i.e. y axis because we want to manipulate the style of points individually if we want to)
  
        geom_segment(aes(x = 0.496, y = 5, xend = 3.504, yend = 5), color="black", size=0.3) +
        geom_segment(aes(x = 0.496, y = 4, xend = 3.504, yend = 4), color="black", size=0.3) +
        geom_segment(aes(x = 0.496, y = 2, xend = 3.504, yend = 2), color="black", size=0.3) +
        geom_segment(aes(x = 0.496, y = 1, xend = 3.504, yend = 1), color="black", size=0.3) +
        geom_segment(aes(x = 0.496, y = 0, xend = 3.504, yend = 0), color="black", size=0.3) +
  
  # then we add the lines that we want joining the timepoints first because we want the points to be overlaid onto the lines as opposed to the other way round
  
        geom_point(aes(y=0), col = ifelse(1:nrow(data) == 1:3, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1:3, 13, 16),
                   size = ifelse(1:nrow(data) == 1:3, 7, 0),
                   stroke = ifelse(1:nrow(data) == 1:3, 2, 0), fill="white") +
        
        geom_point(aes(y=1), col = ifelse(1:nrow(data) == 1:3, "black", "black"),
                   shape = ifelse(1:nrow(data) == 1, 21, ifelse(1:nrow(data) == 2, 21, ifelse(1:nrow(data) == 3, 13, 16))),
                   size = ifelse(1:nrow(data) == 1:3, 7, -1), 
                   stroke = ifelse(1:nrow(data) == 1:3, 2, 0), 
                   fill = ifelse(1:nrow(data) == 1, "gray", "white")) +
        
        geom_point(aes(y=2), col = ifelse(1:nrow(data) == 1:3, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1, 21, ifelse(1:nrow(data) == 2, 13, ifelse(1:nrow(data) == 3, 13, 16))),
                   size = ifelse(1:nrow(data) == 1:3, 7, -1), 
                   stroke = ifelse(1:nrow(data) == 1:3, 2, 0), fill="white") +
        
        geom_point(aes(y=4), col = ifelse(1:nrow(data) == 1:3, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1, 21, ifelse(1:nrow(data) == 2, 13, ifelse(1:nrow(data) == 3, 21, 16))),
                   size = ifelse(1:nrow(data) == 1:3, 7, -1),
                   stroke = ifelse(1:nrow(data) == 1:3, 2, 0), 
                   fill = ifelse(1:nrow(data) == 1, "gray", "white")) +
        
        geom_point(aes(y=5), col = ifelse(1:nrow(data) == 1:3, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1, 21, ifelse(1:nrow(data) == 2, 21, ifelse(1:nrow(data) == 3, 21, 16))),
                   size = ifelse(1:nrow(data) == 1:3, 7, -1), 
                   stroke = ifelse(1:nrow(data) == 1:3, 2, 0), 
                   fill = ifelse(1:nrow(data) == 1, "gray", "white")) +
  
  # then we add the points where y=n add points, using ifelse to control whether we show the plotted point or not i.e. for initiators (y=5), the dataframe has a value for every value of x but we only want to plot the point for x=3, so in geom_point we can say if the 3rd row in the dataframe (because 1:3 in the dataframe represents all values of y) plot a circle with a black outline if not plot a point we can't see
  
        geom_segment(aes(x = 0.5, y =-0.7, xend = 0.5, yend = 5.01), color="grey", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 1.5, y =-0.7, xend = 1.5, yend = 5.01), color="grey", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 2.5, y =-0.7, xend = 2.5, yend = 5.01), color="red", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 3.5, y =-0.7, xend = 3.5, yend = 5.01), color="red", linetype="longdash", size=0.3) +
  
  # here add the segmented grey and red lines denoting timeframes tracked up from the x axis
  
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "white"), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank(), axis.title = element_blank()) +
  
  # remove all themes, axes and numbers originally plotted by ggplot
  
      geom_segment(aes(x = 0.5, y = -0.7, xend = 3.5, yend = -0.7), color="black") +
  
  # create a fake x axis having got rid of the original one provided by ggplot
  
      geom_segment(aes(x = 0.5, y = -0.8, xend = 0.5, yend = -0.681), color="black", size=0.3) +
      geom_segment(aes(x = 1.5, y = -0.8, xend = 1.5, yend = -0.681), color="black", size=0.3) +
      geom_segment(aes(x = 2.5, y = -0.8, xend = 2.5, yend = -0.681), color="black", size=0.3) +
      geom_segment(aes(x = 3.5, y = -0.8, xend = 3.5, yend = -0.681), color="black", size=0.3) +
  
  # add tick lines to the fake x axis you've just made
  
      annotate(geom= "text", x = -1, y = 0, label = "No antidepressant prescriptions", size=3.5,hjust="left") +
      annotate(geom= "text", x = -1, y = 1, label = "Late pre-pregnancy discontinuers", size=3.5,hjust="left") +
      annotate(geom= "text", x = -1, y = 2, label = "Early pre-pregnancy discontinuers", size=3.5,hjust="left") +
      annotate(geom= "text", x = -1, y = 4, label = "Incident users", size=3.5,hjust="left") +
      annotate(geom= "text", x = -1, y = 5, label = "Prevalent users", size=3.5,hjust="left") +
  
  # add in text showing what each of the timelines you've created (mirroring y axis labels)
  
      annotate(geom= "text", x = 1, y = -1, label = "3-12 months", size=3.5, fontface="bold", hjust="center") +
      annotate(geom= "text", x = 2, y = -1, label = "0-3 months", size=3.5, fontface="bold", hjust="center") +
      annotate(geom= "text", x = 3, y = -1, label = "Trimesters 1-3", size=3.5, fontface="bold", hjust="center") +
      
  # describe sections along the fake x axis segmented by the grey and red dashed lines
  
      annotate(geom ="label", x = -1.2, y = 5.7,label = "Antidepressant exposure during pregnancy",colour = "black", size=4, fontface="bold", hjust="left") +
      annotate(geom ="label", x = -1.2, y = 3,label = "No antidepressant exposure during pregnancy",colour = "black", size=4, fontface="bold", hjust="left") +
  
  # provide section headers for each group of timelines
  
      annotate(geom= "label", x = 1.5, y = -1.5, label = "Before pregnancy", size=3.5, hjust="center") +
      annotate(geom= "label", x = 3, y = -1.5, label = "During pregnancy", size=3.5, hjust="center") +
  
  # provide section headers for each group of time periods
  
      annotate(geom= "text", x = -0.9, y = -1.5, label = "An antidepressant prescription must occur in this period", size=2.5,hjust="left") +
      annotate(geom= "text", x = -0.9, y = -1.8, label = "An antidepressant prescription must not occur in this period", size=2.5,hjust="left") +
      annotate(geom= "text", x = -0.9, y = -2.1, label = "An antidepressant prescription may or may not occur in this period", size=2.5,hjust="left") +
      
      annotate("pointrange", x = -1, y = -1.5, ymin = -1.8, ymax = -1.8, colour = "black", size = 1, shape = 21) +
      annotate("pointrange", x = -1, y = -1.8, ymin = -1.8, ymax = -1.8, colour = "black", size = 1, shape = 13) +
      annotate("pointrange", x = -1, y = -2.1, ymin = -1.8, ymax = -1.8, colour = "black", size = 1, shape = 21, fill="gray") +
  
  # make a fake key using pointrange in annotate to give us the shape (giving it no range so it doesn't have the CI tails) and text in annotate to write what the shape means
  
      ylim(-2.2,6) + 
      xlim(-1.2,4) 
  
    # set the size of the output to adequately compress the graph into the right shape
    
    # done! 
    # if text appears to be overlapping with the figure elements in preview mode (right) try making the console smaller (dragging the separating line to the left) before changing text positioning within the figure
  
    ggsave("figure_1.pdf", plot=last_plot(), dpi=300)
    
    # save A5 landscape with current dimensions & positions
