function Params = stimdefNILD(EXP);
% stimdefNILD - definition of stimulus and GUI for NILD stimulus paradigm
%    P=stimdefNITD(EXP) returns the definition for the NILD (noise-ILD)
%    stimulus paradigm. The definition P is a GUIpiece that can be rendered
%    by GUIpiece/draw. Stimulus definition like stimmdefZW are usually
%    called by StimGUI, which combines the parameter panels with
%    a generic part of stimulus GUIs. The input argument EXP contains 
%    Experiment definition, which co-determines the realization of
%    the stimulus: availability of DAC channels, calibration, recording
%    side, etc.
%
%    See also stimGUI, stimDefDir, Experiment, makestimNILD.
% 
%    Created by Gowtham 28/8/20 

% ---Noise
Noise = NoisePanel('Noise Param', EXP, [],{'SPL' 'AltLevel' 'Reverse' 'DAC'}); % include SPL etc

% ---SAM and SPLweep from ILD
ILD = SPLstepperNILD('ILD', EXP);

% ---Durations
Dur = DurPanel('Durations', EXP, '', 'nophase');
% ---Pres
Pres = PresentationPanel;
% ---Summary
summ = Summary(23);
%====================
Params=GUIpiece('Params'); % upper half of GUI: parameters
Params = add(Params, summ);
Params = add(Params, Noise, nextto(summ), [10 0]);
Params = add(Params, ILD, below(Noise));
Params = add(Params, Pres, nextto(ILD) ,[10 0]);
Params = add(Params, Dur, nextto(Noise), [10 0]);
Params = add(Params, PlayTime(), below(ILD) ,[0 5]);




