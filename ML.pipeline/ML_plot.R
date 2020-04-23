#R code: Plots the -logL values of each IQ-tree run and highlights minimum, maximum and mean values.
#NOTE: ggplot2 library must be installed

library(ggplot2)
logL=read.table("LogL.comparison.txt")
max=logL[which.max(logL$V2),]
mean=mean(logL$V2)
e = ggplot(logL, aes(x=V1, y=V2, group=1)) +
	geom_line(aes(y=V2,x=V1)) +
	labs(y="logL", x="Tree") +
	geom_point(data=max, aes(x=V1,y=V2,),color="orange",size=4,shape=18) +
	geom_hline(aes(yintercept=mean), linetype="dashed",colour="#BB0000") +
	theme_bw() +
	theme(axis.text.x = element_text(angle = 90, vjust=0.5,size = 4), panel.grid.minor = element_blank())

ggsave("ML.comparison.pdf")
dev.off() 
