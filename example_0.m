% 20201119 by Dushan N. Wadduwage (wadduwage@fas.harvard.edu)
% An example code for MC-spf simulation

pram = f_praminit();  % initializes all paramteres. Take a look at 'f_praminit.m' for details

pram.z0_um    = -100;
pram.Nphotons = 100000;
main(pram);           % runs simulation for parameters in 'pram' ...
                      % and saves results to folder defined by 'pram.savepath' 
                      
% load sPSF.mat
% f_plotResults(sPSF,sPSF_axis,x_backProp,y_backProp,pram);