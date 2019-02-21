function Params = stimdefCSPL(EXP)
% stimdefCSPL - definition of stimulus and GUI for CSPL stimulus paradigm
%    P=stimdefCSPL(EXP) returns the definition for the CSPL (Rate Curve Modulation)
%    stimulus paradigm. The definition P is a GUIpiece that can be rendered
%    by GUIpiece/draw. Stimulus definition like stimdefCSPL are usually
%    called by StimGUI, which combines the parameter panels with
%    a generic part of stimulus GUIs. The input argument EXP contains 
%    Experiment definition, which co-determines the realization of
%    the stimulus: availability of DAC channels, calibration, recording
%    side, etc.
%
%    See also stimGUI, stimDefDir, Experiment, makestimCSPL.

PairStr = ' Pairs of numbers are interpreted as [left right].';
ClickStr = ' Click button to select ';

%==========SPL Stepper GUIpanel=====================
SPLsweep = SPLstepper('SPL', EXP);

%==========Amplitude Generation panel===============
AmpRef = ClickAmpRefPanel('Amplitude value definition');
AmpRef = sameextent(AmpRef,SPLsweep,'X'); % adjust width of Mod to match Freq

freqPanel = FreqPanel('click frequency', EXP);

% ---Clicks
Clicks = ClickPanel('click parameters', EXP);
Clicks = sameextent(Clicks,SPLsweep,'X'); % adjust width of Mod to match Freq

% ---Pres
Pres = PresentationPanel;
% ---Durations
Dur = DurPanelClicks('-', EXP);
Dur = sameextent(Dur,Pres,'Y');
% ---Summary
summ = Summary(17);

%====================
%! you need to add an object to the GUIpiece before you can refere to it
%via below(), nextto(),... functions
Params=GUIpiece('Params'); % upper half of GUI: parameters
Params = add(Params, summ);
Params = add(Params, SPLsweep, nextto(summ), [10 0]);
Params = add(Params, AmpRef, below(SPLsweep), [0 6]);
Params = add(Params, Clicks, below(AmpRef), [0 6]);
Params = add(Params, freqPanel, nextto(SPLsweep), [10 0]);
Params = add(Params, Dur, below(freqPanel), [0 10]);
Params = add(Params, Pres, nextto(Dur), [5 0]);
Params = add(Params, PlayTime, below(Dur), [0 6]);


