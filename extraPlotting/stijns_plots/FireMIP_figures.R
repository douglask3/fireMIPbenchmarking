
##### seasonality plot ############

df2 = read.table("extraPlotting/stijns_plots/season_NH.txt")
df3 = read.table("extraPlotting/stijns_plots/season_Nec.txt")
df4 = read.table("extraPlotting/stijns_plots/season_Sec.txt")
df5 = read.table("extraPlotting/stijns_plots/season_SH.txt")

plotLineWithRange <- function(x, yVal, yMin, yMax,lineColor="Black", rangeColor="LightGrey",main=""){
  if(missing(x)){
    x <- 1:length(yVal)
  }
  stopifnot(length(yVal) == length(yMin) && length(yVal) == length(yMax))
  
  polygon(x=c(x,rev(x)),y=c(yMax,rev(yVal)),col=rangeColor,border=NA)
  polygon(x=c(x,rev(x)),y=c(yMin,rev(yVal)),col=rangeColor,border=NA)
  lines(x=x,y=yVal,col=lineColor,lwd=2.3)
}


pr = df2

pr$V1 = (pr$V1/(sum(pr$V1)))*100
pr$V2 = (pr$V2/(sum(pr$V2)))*100
pr$V3 = (pr$V3/(sum(pr$V3)))*100
pr$V4 = (pr$V4/(sum(pr$V4)))*100
pr$V5 = (pr$V5/(sum(pr$V5)))*100
pr$V6 = (pr$V6/(sum(pr$V6)))*100
pr$V7 = (pr$V7/(sum(pr$V7)))*100
pr$V8 = (pr$V8/(sum(pr$V8)))*100
pr$V9 = (pr$V9/(sum(pr$V9)))*100
pr$V10 = (pr$V10/(sum(pr$V10)))*100
pr$V11 = (pr$V11/(sum(pr$V11)))*100

pr$max = apply(pr[, c(3, 7,9,10,11)], 1, max)
pr$min = apply(pr[, c(3, 7,9,10,11)], 1, min)
pr$mean = apply(pr[, c(3, 7,9,10,11)], 1, mean)
par(mfrow=c(2,2))
par(mar=c(5,5,0,0))
par(oma=c(7,1,1,1))
plot(pr$V1, type="l", ylim=c(0,30), xlab="",ylab= "% burnt area", cex.lab=2,cex.axis=2)
plotLineWithRange(yVal=pr$mean,yMin=pr$min,yMax=pr$max)
lines(pr$V2, col="green2", lwd=2)
lines(pr$V1, col="blueviolet", lwd=2)
lines(pr$V4, col="red3", lwd=2)
lines(pr$V5, col="chocolate2", lwd=2)
lines(pr$V6, col="springgreen4", lwd=2)
lines(pr$V8, col="steelblue2", lwd=2)

text(3,29,"a) Northern extratropic",cex=2)


pr = df3

pr$V1 = (pr$V1/(sum(pr$V1)))*100
pr$V2 = (pr$V2/(sum(pr$V2)))*100
pr$V3 = (pr$V3/(sum(pr$V3)))*100
pr$V4 = (pr$V4/(sum(pr$V4)))*100
pr$V5 = (pr$V5/(sum(pr$V5)))*100
pr$V6 = (pr$V6/(sum(pr$V6)))*100
pr$V7 = (pr$V7/(sum(pr$V7)))*100
pr$V8 = (pr$V8/(sum(pr$V8)))*100
pr$V9 = (pr$V9/(sum(pr$V9)))*100
pr$V10 = (pr$V10/(sum(pr$V10)))*100
pr$V11 = (pr$V11/(sum(pr$V11)))*100

pr$max = apply(pr[, c(3, 7,9,10,11)], 1, max)
pr$min = apply(pr[, c(3, 7,9,10,11)], 1, min)
pr$mean = apply(pr[, c(3, 7,9,10,11)], 1, mean)

plot(pr$V1, type="l", ylim=c(0,30), xlab = "",ylab = "", cex.lab=2,cex.axis=2)
plotLineWithRange(yVal=pr$mean,yMin=pr$min,yMax=pr$max)
lines(pr$V2, col="green2", lwd=2)
lines(pr$V1, col="blueviolet", lwd=2)
lines(pr$V4, col="red3", lwd=2)
lines(pr$V5, col="chocolate2", lwd=2)
lines(pr$V6, col="springgreen4", lwd=2)
lines(pr$V8, col="steelblue2", lwd=2)

text(2.7,29,"b) Northern tropics",cex=2)


pr = df4

pr$V1 = (pr$V1/(sum(pr$V1)))*100
pr$V2 = (pr$V2/(sum(pr$V2)))*100
pr$V3 = (pr$V3/(sum(pr$V3)))*100
pr$V4 = (pr$V4/(sum(pr$V4)))*100
pr$V5 = (pr$V5/(sum(pr$V5)))*100
pr$V6 = (pr$V6/(sum(pr$V6)))*100
pr$V7 = (pr$V7/(sum(pr$V7)))*100
pr$V8 = (pr$V8/(sum(pr$V8)))*100
pr$V9 = (pr$V9/(sum(pr$V9)))*100
pr$V10 = (pr$V10/(sum(pr$V10)))*100
pr$V11 = (pr$V11/(sum(pr$V11)))*100

pr$max = apply(pr[, c(3, 7,9,10,11)], 1, max)
pr$min = apply(pr[, c(3, 7,9,10,11)], 1, min)
pr$mean = apply(pr[, c(3, 7,9,10,11)], 1, mean)

plot(pr$V1, type="l", ylim=c(0,30), xlab = "month", ylab= "% burnt area", cex.lab=2,cex.axis=2)
plotLineWithRange(yVal=pr$mean,yMin=pr$min,yMax=pr$max)
lines(pr$V2, col="green2", lwd=2)
lines(pr$V1, col="blueviolet", lwd=2)
lines(pr$V4, col="red3", lwd=2)
lines(pr$V5, col="chocolate2", lwd=2)
lines(pr$V6, col="springgreen4", lwd=2)
lines(pr$V8, col="steelblue2", lwd=2)

text(2.7,29,"c) Southern tropics",cex=2)


pr = df5

pr$V1 = (pr$V1/(sum(pr$V1)))*100
pr$V2 = (pr$V2/(sum(pr$V2)))*100
pr$V3 = (pr$V3/(sum(pr$V3)))*100
pr$V4 = (pr$V4/(sum(pr$V4)))*100
pr$V5 = (pr$V5/(sum(pr$V5)))*100
pr$V6 = (pr$V6/(sum(pr$V6)))*100
pr$V7 = (pr$V7/(sum(pr$V7)))*100
pr$V8 = (pr$V8/(sum(pr$V8)))*100
pr$V9 = (pr$V9/(sum(pr$V9)))*100
pr$V10 = (pr$V10/(sum(pr$V10)))*100
pr$V11 = (pr$V11/(sum(pr$V11)))*100

pr$max = apply(pr[, c(3, 7,9,10,11)], 1, max)
pr$min = apply(pr[, c(3, 7,9,10,11)], 1, min)
pr$mean = apply(pr[, c(3, 7,9,10,11)], 1, mean)

plot(pr$V1, type="l", ylim=c(0,30),xlab="month",ylab="",cex.lab=2,cex.axis=2)
plotLineWithRange(yVal=pr$mean,yMin=pr$min,yMax=pr$max)
lines(pr$V2, col="green2", lwd=2)
lines(pr$V1, col="blueviolet", lwd=2)
lines(pr$V4, col="red3", lwd=2)
lines(pr$V5, col="chocolate2", lwd=2)
lines(pr$V6, col="springgreen4", lwd=2)
lines(pr$V8, col="steelblue2", lwd=2)

text(3.3,29,"d) Southern extratropics",cex=2)


par(fig = c(0, 1, 0, 1), oma = c(0, 0, 0, 0), mar = c(0, 0, 0, 0), new = TRUE)
plot(0, 0, type = "n", bty = "n", xaxt = "n", yaxt = "n")

legend("bottom",c("CLM","CLASS-CTEM","JULES-INFERNO","JSBACH-SPITFIRE","LPJ-GUESS-SPITFIRE","ORCHIDEE-SPITFIRE", "Observations"),xpd=T,lwd=3,
       lty=c(1,1,1,1,1,1,1),col=c("blueviolet","green2","red3","chocolate2","springgreen4","steelblue2", "black"),bty = "n",cex=2,seg.len=1.5,ncol=3)



##################  IAV plot   ##################
##############################################################################

dd = read.table("~/IAV_data_fig.txt",header=T)
dd=dd*100
dd <- dd[-nrow(dd),] 
year=c(2001:2012)

plotLineWithRange_obs <- function(x, yVal, yMin, yMax,
                              lineColor="Black", rangeColor=transparent("Black",trans.val = 0.5),
                              main=""){
  if(missing(x)){
    x <- year
  }
  stopifnot(length(yVal) == length(yMin) && length(yVal) == length(yMax))
  
  polygon(x=c(x,rev(x)),y=c(yMax,rev(yVal)),col=rangeColor,border=NA)
  polygon(x=c(x,rev(x)),y=c(yMin,rev(yVal)),col=rangeColor,border=NA)
}

plotLineWithRange_mod <- function(x, yVal, yMin, yMax,
                              lineColor="Black", rangeColor=transparent("Blue",trans.val = 0.5),
                              main=""){
  if(missing(x)){
    x <- year
  }
  stopifnot(length(yVal) == length(yMin) && length(yVal) == length(yMax))
  
  polygon(x=c(x,rev(x)),y=c(yMax,rev(yVal)),col=rangeColor,border=NA)
  polygon(x=c(x,rev(x)),y=c(yMin,rev(yVal)),col=rangeColor,border=NA)
}


dd$max_obs = apply(dd[, c(10,11,12,13)], 1, max,na.rm=TRUE)
dd$min_obs = apply(dd[, c(10,11,12,13)], 1, min,na.rm=TRUE)
dd$mean_obs = apply(dd[, c(10,11,12,13)], 1, mean,na.rm=TRUE)

dd$max_mod = apply(dd[, c(1,2,3,4,5,6,7,8,9)], 1, quantile, probs=c(.80),type=1,na.rm=TRUE)
dd$min_mod = apply(dd[, c(1,2,3,4,5,6,7,8,9)], 1, quantile,probs=c(.20),type=1,na.rm=TRUE)
dd$mean_mod = apply(dd[, c(1,2,3,4,5,6,7,8,9)], 1, mean,na.rm=TRUE)

plot(year,dd$CLM, type="l", ylim=c(-25,25),xlab="year",ylab="change in burnt area (%)",cex.lab=1.3,cex.axis=1.3, col=transparent("black",trans.val = 1))
plotLineWithRange_obs(yVal=dd$mean_obs,yMin=dd$min_obs,yMax=dd$max_obs)

lines(year,dd$CTEM, col="green2", lwd=1.3)
lines(year,dd$CLM, col="blueviolet", lwd=1.3)
lines(year,dd$JULES.INFERNO , col="red3", lwd=1.3)
lines(year,dd$JSBACH.SPITFIRE, col="chocolate2", lwd=1.3)
lines(year,dd$LPJ.GUESS.SPITFIRE , col="springgreen4", lwd=1.3)
lines(year,dd$ORCHIDEE.SPITFIRE , col="steelblue2", lwd=1.3)
lines(year,dd$LPJ.GUESS.GlobFIRM , col="midnightblue", lwd=1.3)
lines(year,dd$LPJ.GUESS.SIMFIRE.BLAZE , col="blue", lwd=1.3)
lines(year,dd$MC2 , col="lightsalmon", lwd=1.3)

legend("top",c("CLM","CLASS-CTEM","JULES-INFERNO","JSBACH-SPITFIRE","LPJ-GUESS-SPITFIRE","ORCHIDEE-SPITFIRE", "LPJ-GUESS-GlobFIRM","LPJ-GUESS-SIMFIRE-BLAZE","MC2","Observations"),xpd=T,lwd=3,lty=c(1,1,1,1,1,1,1),col=c("blueviolet","green2","red3","chocolate2","springgreen4","steelblue2","midnightblue","blue","lightsalmon", "grey"),bty = "n",cex=1,seg.len=1.5,ncol=1)

legend("bottom",c("model range", "Observation range"),xpd=T,lwd=8,
       lty=c(1,1),col=c(transparent("Blue",trans.val = 0.5),transparent("Black",trans.val = 0.5)),bty = "n",cex=1,seg.len=1.5,ncol=1)







