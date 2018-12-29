library("crosstalk")
library("GGally")

d <- SharedData$new(iris)
p <- GGally::ggpairs(d, aes(color = Species), columns = 1:4)
#highlight(ggplotly(p), on = "plotly_selected") # plotly function highlighting