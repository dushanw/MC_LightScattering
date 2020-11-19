% 20201119 by Dushan N. Wadduwage (wadduwage@fas.harvard.edu)
% An example code for MC-spf simulation

pram = f_praminit();  % initializes all paramteres. Take a look at 'f_praminit.m' for details
main(pram);           % runs simulation for parameters in 'pram' ...
                      % and saves results to folder defined by 'pram.savepath' 