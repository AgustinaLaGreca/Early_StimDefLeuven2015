function Params = stimdefZUREK(EXP);
% stimdefZUREK - definition of stimulus and GUI for DIZON stimulus paradigm
%    P=stimdefZUREK(EXP) returns the definition for the DIZON stimulus paradigm. 
%    The definition P is a GUIpiece that can be rendered by GUIpiece/draw. 
%    Stimulus definition like stimdefDIZON are usually called by StimGUI, 
%    which combines the parameter panels with
%    a generic part of stimulus GUIs. The input argument EXP contains 
%    Experiment definition, which co-determines the realization of
%    the stimulus: availability of DAC channels, calibration, recording
%    side, etc.
%
%    See also stimGUI, stimDefDir, Experiment, makestimDIZON.
% 
%   Created by Gowtham Aug 2020

% ---ITD sweep
ITD = ITDstepperZUREK('Source (Noise)', EXP, '');
echo = ZUREKecho('Echo', EXP, '');
% ---Durations
Dur = DurPanel('Durations', EXP, '', 'basicsonly');
% ---Presentation
Pres = PresentationPanel;
% ---Summary
summ = Summary(27);

%====================
Params=GUIpiece('Params'); % upper half of GUI: parameters
Params = add(Params, summ, 'nextto',[8 0]);
Params = add(Params, ITD, nextto(summ), [10 0]);
Params = add(Params, echo, nextto(ITD), [10 0]);
Params = add(Params, Dur, below(ITD), [0 0]);
Params = add(Params, Pres, below(echo) ,[0 0]);
Params = add(Params, PlayTime(), below(Dur) , [0 8]);




