#library("car")
#x1<-minecraft_pos_log_VP24_Tag1_neu.csv$x;
#y1<-minecraft_pos_log_VP24_Tag1_neu.csv$y;
#z1<-minecraft_pos_log_VP24_Tag1_neu.csv$z;
#x2<-minecraft_pos_log_VP26_Tag1_neu.csv$x;
#y2<-minecraft_pos_log_VP26_Tag1_neu.csv$y;
#z2<-minecraft_pos_log_VP26_Tag1_neu.csv$z;
#x = c(x1,x2);
#y = c(y1,y2);
#z = c(z1,z2);
#color = factor(c(rep(0,length(x1)),rep(1,length(x2))));
#scatter3d(x,y,z,group=color,surface = FALSE);


# Plots basic information about the dataset
createSimpleDataOverview <- function(dataset){
  View(dataset)
}

