% function sig=generate_schroeder(f0,C,T,fs,high_freq_limit)
% f0      fundamental frequency                                   Unit: Hertz

% C       speed of frequency shift                                Unit: none
% T       length of the schröder phase tone                       Unit: seconds
% high_freq_limit  Highest frequency in complex                Hz
% fs      sampling frequency                                        Unit: Hertz default fs=48000 Hz

% Output
% sig       vector of the computed Schroeder Phase

%  Carney parameters:  
f0 = 100;
fs = 2.4414e+04;
T = 1.1;
%     100 200 400]
C = 1;
%  : 0.25 : +1.0]
% although more recently I'm shortening this to  C = [-1:  0.5 : 1.0]
%  Used duration of 04 sec
%  Note that fundamental was included here - in some psychophysical studies,
%  the fundamental is excluded.
high_freq_limit = 500;
N = floor(high_freq_limit/f0);   % # of components in complex

%% Timevector
t=0:1/fs:T-1/fs;

%% Sum the fundamental and its harmonics to build the Schröder phase complex
sig=zeros(1,round(fs*T));

for n=1:N
    
    phi_shift=C*pi*n*(n+1)/N;
    
    sig=sig+0.6*sin(2*pi*t*f0*n + phi_shift);
end
figure
plot(t,sig)
% end