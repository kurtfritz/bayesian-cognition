# Simple Bayesian model to infer bias of a coin.

# Resolution of all parameters. How fine-grained is the grid?
res = 100 
# Set Unit interval based on resolution
UnitInt = seq(1/res^2,1-1/res^2,length.out=res) 

# Parameters for a beta distribution
omega = 0.5
kappa = 4

a = omega * (kappa - 2) + 1 
b = (1 - omega) * (kappa - 2) + 1 

# the 'Data'
N = 20 
z = 17

# Prior distribution over theta
Theta = UnitInt # Possible theta values
dThetaBeta = dbeta(Theta,a,b) # The prior on theta as a density
pTheta = dThetaBeta*abs(Theta[2]-Theta[1]) # convert density to a mass function

pDataGivenTheta = Theta^z * (1 - Theta)^(N-z) # Likelihood
pData = sum( pDataGivenTheta * pTheta) # In place of an integral 
pThetaGivenData = pDataGivenTheta * pTheta / pData # Bayes Theorem!

# Plot the results.
layout( matrix( c( 1,2,3 ) ,nrow=3 ,ncol=1 ,byrow=FALSE ) ) # 3x1 panels
par( mar=c(3,3,1,0) , mgp=c(2,0.7,0) , mai=c(0.5,0.5,0.3,0.1) ) # margins

plotType = "l" # Plot Bars

plot( Theta , pTheta , type=plotType , lwd=3,
     yaxt='n', xlab=bquote(theta) , ylab=bquote(p(theta)),
     main="Prior" , col="plum1" )
plot( Theta , pDataGivenTheta , type=plotType , lwd=3,
     yaxt='n', xlab=bquote(theta) , ylab=bquote( "p(D|" * theta * ")" ) ,
     main="Likelihood" , col="plum1" )
plot( Theta, pThetaGivenData, type=plotType , lwd=3,
     yaxt='n', xlab=bquote(theta) , ylab=bquote( "p(" * theta * "|D)" ) ,
     main="Posterior" , col="plum1" )
abline(lwd=3, v=weighted.mean(Theta,pThetaGivenData), col='plum1')
 