library(readr)
library(dplyr)
library(scales)
library(ggplot2)
library(reshape2)

#Import Data
urlfile="https://raw.githubusercontent.com/Daniel-Pailanir/Cuarentenas/master/Cuarentenas.csv"

#Reshape Data
mydata <-read_csv(url(urlfile))
mydata <- melt(mydata, id = c("comuna","nombre","region"), 
               variable.name = "date", value.name = "quarantine")
mydata2 <- mydata %>% group_by(date) %>% summarise(Nquarantine = sum(quarantine, na.rm = T)) 
mydata2$date <- as.Date(mydata2$date, "%d-%m-%Y")

#Graph
ggplot(mydata2, 
             aes(x = date, 
                 y = Nquarantine)) + 
  geom_line(size = 0.5, 
            alpha = 0.7, 
            color = "darkgreen") +  
  scale_x_date(labels = date_format("%d %b"), 
               breaks = '15 days') +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
  labs(y = "", 
       x = "", 
       title = "Comunas en Cuarentena") +
  theme_bw() +
  theme(panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 45, 
                                   hjust = 1))

ggsave("Quarantine.png", dpi=550)
