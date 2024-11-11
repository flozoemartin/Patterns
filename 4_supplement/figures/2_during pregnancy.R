################################################################################

# Distinguishing patterns of prescribing during pregnancy

# Author: Flo Martin

# Date: 17/10/2022

################################################################################

# Load in the package we're using & set working directory

install.packages("ggplot2")
install.packages("ggtext")

library(ggplot2)
library(ggtext)

setwd("/file/space/for/graph/files/1_patterns of prescribing")

# Now for the next figure describing patterns of prescribing within pregnancy among those exposed (incident and prevalent) 

# Make the dataframe

    pattern <- c(0,0,0,0,0,0,0,0,0,0,0,0,
                 1,1,1,1,1,1,1,1,1,1,1,1,
                 2,2,2,2,2,2,2,2,2,2,2,2,
                 3,3,3,3,3,3,3,3,3,3,3,3,
                 4,4,4,4,4,4,4,4,4,4,4,4,
                 5,5,5,5,5,5,5,5,5,5,5,5,
                 6,6,6,6,6,6,6,6,6,6,6,6,
                 8,8,8,8,8,8,8,8,8,8,8,8,
                 9,9,9,9,9,9,9,9,9,9,9,9,
                 10,10,10,10,10,10,10,10,10,10,10,10)

# similarly to the figure above, split groups of patterns by skipping values of y to give that level of separation between groups

    timing <- c(1,1,1,1.96,1.96,2.03,2.96,2.96,3.03,3.96,3.96,4.03,
                0.94,1,1.06,1.96,1.96,2.03,2.96,2.96,3.03,3.96,3.96,4.03,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4,
                1,1,1,2,2,2,3,3,3,4,4,4)

# given that we want to show multiple (max 3) prescriptions at one timepoint, using values of x that overlay with one another was important to show both during the same prescription event
# 3 points per timepoint per pattern overlapping completely if only one prescription event at that timepoint in that pattern, split out if more than one

    data <- data.frame(pattern,timing)
    
    ggplot(data, aes(timing, pattern)) +
  
  # Make the figure
  
        geom_segment(aes(x = 0.495, y = 0, xend = 4.505, yend = 0), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 1, xend = 4.505, yend = 1), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 2, xend = 4.505, yend = 2), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 3, xend = 4.505, yend = 3), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 4, xend = 4.505, yend = 4), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 5, xend = 4.505, yend = 5), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 6, xend = 4.505, yend = 6), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 8, xend = 4.505, yend = 8), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 9, xend = 4.505, yend = 9), color="black", size=0.3) +
        geom_segment(aes(x = 0.495, y = 10, xend = 4.505, yend = 10), color="black", size=0.3) +
  
  # then we add the lines that we want joining the timepoints first because we want the points to be overlaid onto the lines as opposed to the other way round
  
        geom_point(aes(y=0), col = ifelse(1:nrow(data) == 1:12, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1:12, 21, 16),
                   size = ifelse(1:nrow(data) == 1:12, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 1:12, 1.5, 0), fill="white") +
        
        geom_point(aes(y=1), col = ifelse(1:nrow(data) == 1:12, "black", "white"),
                   shape = ifelse(1:nrow(data) == 1:12, 21, 16),
                   size = ifelse(1:nrow(data) == 1:12, 4.4, -1),
                   stroke = ifelse(1:nrow(data) == 1:12, 1.5, 0), fill="white") +
        geom_point(aes(y=1), col = ifelse(1:nrow(data) == 13:14, "black", "white"),
                   shape = ifelse(1:nrow(data) == 13:14, 21, 16),
                   size = ifelse(1:nrow(data) == 13:14, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 13:14, 1.5, 0), fill="white") +
        geom_point(aes(y=1), col = ifelse(1:nrow(data) == 15, "black", "white"),
                   shape = ifelse(1:nrow(data) == 15, 21, 16),
                   size = ifelse(1:nrow(data) == 15, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 15, 1.5, 0), fill="white") +
      
      
      geom_point(aes(y=2), col = ifelse(1:nrow(data) == 61:72, "black", "white"),
                 shape = ifelse(1:nrow(data) == 61:72, 21, 16),
                 size = ifelse(1:nrow(data) == 61:72, 4.4, -1), 
                 stroke = ifelse(1:nrow(data) == 61:72, 1.5, 0), fill="white") +
        
        geom_point(aes(y=3), col = ifelse(1:nrow(data) == 25, "black", ifelse(1:nrow(data) == 28, "black", ifelse(1:nrow(data) == 31, "black", ifelse(1:nrow(data) == 34, "black", "white")))),
                   shape = ifelse(1:nrow(data) == 25, 21, ifelse(1:nrow(data) == 28, 21, ifelse(1:nrow(data) == 31, 21, ifelse(1:nrow(data) == 34, 21, 16)))),
                   size = ifelse(1:nrow(data) == 25, 4.4, ifelse(1:nrow(data) == 28, 8, ifelse(1:nrow(data) == 31, 1.5, ifelse(1:nrow(data) == 34, 4.4, -1)))),
                   stroke = ifelse(1:nrow(data) == 25, 1.5, ifelse(1:nrow(data) == 28, 1.5, ifelse(1:nrow(data) == 31, 1.5, ifelse(1:nrow(data) == 34, 1.5, 0)))), fill="white") +
        
        geom_point(aes(y=4), col = ifelse(1:nrow(data) == 37:39, "black", ifelse(1:nrow(data) == 40, "black", ifelse(1:nrow(data) == 43, "black", ifelse(1:nrow(data) == 46, "black", "white")))),
                   shape = ifelse(1:nrow(data) == 37:39, 21, ifelse(1:nrow(data) == 40, 21, ifelse(1:nrow(data) == 43, 21, ifelse(1:nrow(data) == 46, 21, 16)))),
                   size = ifelse(1:nrow(data) == 37:39, 4.4, ifelse(1:nrow(data) == 40, 8, ifelse(1:nrow(data) == 43, 8, ifelse(1:nrow(data) == 46, 8, -1)))), 
                   stroke = ifelse(1:nrow(data) == 37:39, 1.5, ifelse(1:nrow(data) == 40, 1.5, ifelse(1:nrow(data) == 43, 1.5, ifelse(1:nrow(data) == 46, 1.5, 0)))), fill="white") +
  
        geom_point(aes(y=5), col = ifelse(1:nrow(data) == 49:51, "black", ifelse(1:nrow(data) == 52, "black", ifelse(1:nrow(data) == 55, "black", ifelse(1:nrow(data) == 58, "black", "white")))),
                   shape = ifelse(1:nrow(data) == 49:51, 21, ifelse(1:nrow(data) == 52, 21, ifelse(1:nrow(data) == 55, 21, ifelse(1:nrow(data) == 58, 21, 16)))),
                   size = ifelse(1:nrow(data) == 49:51, 4.4, ifelse(1:nrow(data) == 52, 1.5, ifelse(1:nrow(data) == 55, 1.5, ifelse(1:nrow(data) == 58, 1.5, -1)))), 
                   stroke = ifelse(1:nrow(data) == 49:51, 1.5, ifelse(1:nrow(data) == 52, 1.5, ifelse(1:nrow(data) == 55, 1.5, ifelse(1:nrow(data) == 58, 1.5, 0)))), fill="white") +
  
        geom_point(aes(y=6), col = ifelse(1:nrow(data) == 73:75, "black", ifelse(1:nrow(data) == 76:80, "black", ifelse(1:nrow(data) == 81:82, "black", "white"))),
                   shape = ifelse(1:nrow(data) == 73:75, 21, ifelse(1:nrow(data) == 76:80, 25, ifelse(1:nrow(data) == 81:82, 25, 16))),
                   size = ifelse(1:nrow(data) == 73:75, 4.4, ifelse(1:nrow(data) == 76:80, 4, ifelse(1:nrow(data) == 81:82, 4, -1))), 
                   stroke = ifelse(1:nrow(data) == 73:75, 1.5, ifelse(1:nrow(data) == 76:80, 1.5, ifelse(1:nrow(data) == 81:82, 1.5, 0))), fill="white") +
        
        geom_point(aes(y=8), col = ifelse(1:nrow(data) == 85:96, "black", "white"),
                   shape = ifelse(1:nrow(data) == 85:91, 21, ifelse(1:nrow(data) == 94:96, 13, 1)),
                   size = ifelse(1:nrow(data) == 85:96, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 85:96, 1.5, 0), 
                   fill = ifelse(1:nrow(data) == 85:90, "gray", "white")) +
        
        geom_point(aes(y=9), col = ifelse(1:nrow(data) == 97:108, "black", "white"),
                   shape = ifelse(1:nrow(data) == 97:102, 21, ifelse(1:nrow(data) == 103:105, 13, ifelse(1:nrow(data) == 105:108, 21, 16))),
                   size = ifelse(1:nrow(data) == 97:108, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 97:108, 1.5, 0), 
                   fill=ifelse(1:nrow(data) == 97:99, "gray", ifelse(1:nrow(data) == 100:105, "white", ifelse(1:nrow(data) == 106:108, "gray", "white")))) +
      
        geom_point(aes(y=10), col = ifelse(1:nrow(data) == 109:120, "black", "white"),
                   shape = ifelse(1:nrow(data) == 109:111, 21, ifelse(1:nrow(data) == 112:114, 13, ifelse(1:nrow(data) == 115:117, 13, ifelse(1:nrow(data) == 118:120, 21, 16)))),
                   size = ifelse(1:nrow(data) == 109:120, 4.4, -1), 
                   stroke = ifelse(1:nrow(data) == 109:120, 1.5, 0),
                   fill=ifelse(1:nrow(data) == 118:120, "gray", "white")) +
        
  # similarly to the figure above, take values of x in each values of y and use ifelse to manipulate each individual point (size, shape etc.) to show change in prescription type over time
  
        geom_segment(aes(x = 0.5, y =-0.7, xend = 0.5, yend = 10.02), color="red", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 1.5, y =-0.7, xend = 1.5, yend = 10.02), color="grey", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 2.5, y =-0.7, xend = 2.5, yend = 10.02), color="grey", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 3.5, y =-0.7, xend = 3.5, yend = 10.02), color="red", linetype="longdash", size=0.3) +
        geom_segment(aes(x = 4.5, y =-0.7, xend = 4.5, yend = 10.02), color="grey", linetype="longdash", size=0.3) +
  
  # here add the segmented grey and red lines denoting timeframes tracked up from the x axis
  
        theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),panel.background = element_blank(), axis.line = element_line(colour = "white"), axis.text.x = element_blank(), axis.text.y = element_blank(), axis.ticks = element_blank(), axis.title = element_blank()) +
        
  # remove all themes, axes and numbers originally plotted by ggplot
  
        annotate(geom= "text", x = -1.8, y = 10, label = "Discontinued in trimester 1", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 9, label = "Discontinued in trimester 2", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 8, label = "Discontinued in trimester 3", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 6, label = "Antidepressant switched", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 5, label = "Dose reduced", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 4, label = "Dose increased", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 3, label = "Dose fluctuated", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 2, label = "No changes to drug regimen", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 1, label = "Antidepressant dropped", size=3.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = 0, label = "Antidepressant added", size=3.5,hjust="left") +
      # add in text showing what each of the timelines you've created (mirroring y axis labels)
        
        annotate(geom ="label", x = -2, y = 11,label = "Discontinuation during pregnancy",colour = "black", size=4, fontface="bold", hjust="left") +
        annotate(geom ="label", x = -2, y = 7,label = "Continuation during pregnancy",colour = "black", size=4, fontface="bold", hjust="left") +
  
  # provide section headers for each group of timelines
  
        geom_segment(aes(x = 0.5, y = -0.7, xend = 4.5, yend = -0.7), color="black", size=0.3) +
        
  # create a fake x axis having got rid of the original one provided by ggplot
  
        geom_segment(aes(x = 0.5, y = -0.691, xend = 0.5, yend = -0.8), color="black", size=0.3) +
        geom_segment(aes(x = 1.5, y = -0.691, xend = 1.5, yend = -0.8), color="black", size=0.3) +
        geom_segment(aes(x = 2.5, y = -0.691, xend = 2.5, yend = -0.8), color="black", size=0.3) +
        geom_segment(aes(x = 3.5, y = -0.691, xend = 3.5, yend = -0.8), color="black", size=0.3) +
        geom_segment(aes(x = 4.5, y = -0.691, xend = 4.5, yend = -0.8), color="black", size=0.3) +
  
  # add tick lines to the fake x axis you've just made
  
        annotate(geom= "text", x = 1, y = -1, label = "Trimester 1", size=3.5,hjust="center", fontface="bold") +
        annotate(geom= "text", x = 2, y = -1, label = "Trimester 2", size=3.5,hjust="center", fontface="bold") +
        annotate(geom= "text", x = 3, y = -1, label = "Trimester 3", size=3.5,hjust="center", fontface="bold") +
        annotate(geom= "text", x = 4, y = -1, label = "0-3 months", size=3.5,hjust="center", fontface="bold") +
  
  # describe sections along the fake x axis segmented by the grey and red dashed lines
  
        annotate(geom= "label", x = 2, y = -1.7, label = "During pregnancy", size=3.5,hjust="center") +
        annotate(geom= "label", x = 4, y = -1.7, label = "After pregnancy", size=3.5,hjust="center") +
  
  # provide section headers for each group of time periods
  
        annotate("pointrange", x = -2, y = -2, ymin = -1.5, ymax = -1.5, colour = "black", size = 1, shape = 21) +
        annotate("pointrange", x = -2, y = -2.7, ymin = -2, ymax = -2, colour = "black", size = 0.8, shape = 25) +
        annotate("pointrange", x = -2, y = -3.4, ymin = -2, ymax = -2, colour = "black", size = 1, shape = 13) +
        annotate("pointrange", x = -2, y = -4.1, ymin = -2, ymax = -2, colour = "black", size = 1, shape = 21, fill="gray") +
        
        annotate(geom= "text", x = -1.8, y = -2, label = "An antidepressant prescription must occur in this period (size relates to dose)", size=2.5,hjust="left") +
        annotate(geom= "text", x = -1.8, y = -2.7, label = "An alternative antidepressant prescription to previous prescription must occur", size=2.5,hjust="left") +
      annotate(geom= "text", x = -1.8, y = -3.4, label = "An antidepressant prescription must not occur in this period", size=2.5,hjust="left") +
      annotate(geom= "text", x = -1.8, y = -4.1, label = "An antidepressant prescription may or may not occur in this period", size=2.5,hjust="left") +
  
  # make a fake key using pointrange in annotate to give us the shape (giving it no range so it doesn't have the CI tails) and text in annotate to write what the shape means
  
        ylim(-4.1,11) + 
        xlim(-2,5) 
    
    # set the size of the output to adequately compress the graph into the right shape
    
    # done!
    
    ggsave("figure_2.pdf", plot=last_plot(), dpi=300)
    
    # Save A5 landscape for these dimensions & positions
