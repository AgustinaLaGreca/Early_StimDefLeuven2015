function Params = stimdefDIZON(EXP);
% stimdefDIZON - definition of stimulus and GUI for DIZON stimulus paradigm
%    P=stimdefDIZON(EXP) returns the definition for the DIZON stimulus paradigm. 
%    The definition P is a GUIpiece that can be rendered by GUIpiece/draw. 
%    Stimulus definition like stimdefDIZON are usually called by StimGUI, 
%    which combines the parameter panels with
%    a generic part of stimulus GUIs. The input argument EXP contains 
%    Experiment definition, which co-determines the realization of
%    the stimulus: availability of DAC channels, calibration, recording
%    side, etc.
%
%    See also stimGUI, stimDefDir, Experiment, makestimDIZON.

% ---ITD sweep
ITD = ITDstepperDIZON('ITD', EXP, ''); 
% ---Durations
Dur = DurPanel('Durations', EXP, '', 'basicsonly');
% ---Presentation
Pres = PresentationPanel;
% ---Noise
Noise = NoisePanel('Noise', EXP,'','Reverse');; % include SPL etc
% ---Summary
summ = Summary(20);

%====================
Params=GUIpiece('Params'); % upper half of GUI: parameters
Params = add(Params, summ);
Params = add(Params, ITD, nextto(summ), [10 0]);
Params = add(Params, Dur, nextto(ITD), [10 0]);
Params = add(Params, Noise, below(ITD), [0 0]);
Params = add(Params, Pres, nextto(Noise) ,[5 -10]);
Params = add(Params, PlayTime(), below(Noise) , [0 10]);




