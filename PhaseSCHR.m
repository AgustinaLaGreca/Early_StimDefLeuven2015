function PhasePanel=PhaseSCHR(T, EXP);
% PhaseSCH
% R - Phase panel for the SCHR stimulus GUIs.
%   F=PhaseHARHAR(Title, EXP) returns a GUIpanel F allowing the 
%   user to specify the phase component of the harmonic.
%   The Guipanel F has title Title. EXP is the experiment 
%   definition, from which the number of DAC channels used (1 or 2) is
%   determined.
%   See StimGUI, GUIpanel, makestimHARHAR.


[Prefix, Flag, Flag2] = arginDefaults('Prefix/Flag/Flag2', '');


% JV: be able to turn Nchan = 2 off, even when EXP.AudioChannelsUsed is 2
if (nargin < 5), Flag = ''; end

% # DAC channels determines the allowed multiplicity of user-specied numbers
if ~isequal(Flag,'nobinaural') && isequal('Both', EXP.AudioChannelsUsed), 
    Nchan = 2;
    PairStr = ' Pairs of numbers are interpreted as [left right].';
else, % single Audio channel
    Nchan = 1;
    PairStr = ''; 
end
ClickStr = ' Click button to select ';

switch EXP.Recordingside,
    case 'Left', Lstr = 'Left=Ipsi'; Rstr = 'Right=Contra';
    case 'Right', Lstr = 'Left=Contra'; Rstr = 'Right=Ipsi';
end
switch EXP.AudioChannelsUsed,
    case 'Left', DACstr = {Lstr};
    case 'Right', DACstr = {Rstr};
    case 'Both', DACstr = {Lstr Rstr 'Both'};
end

%&&&&&&&&



%==========Phase GUIpanel=====================
PhasePanel = GUIpanel('Phase', T);
StartC = ParamQuery([Prefix 'StartC'], 'C Start:', '-1 -1', 'Hz/s', ...
    'rreal', ['Starting speed of frequency shift.' PairStr], Nchan);
StepC = ParamQuery([Prefix 'StepC'], 'C Step:', '0.25 0.25', 'Hz/s', ...
    'rreal', ['Step of speed of frequency shift.' PairStr], Nchan);
EndC = ParamQuery([Prefix 'EndC'], 'C End:', '1 1', 'Hz/s', ...
    'rreal', ['End speed of frequency shift.' PairStr], Nchan);
AdjustC = ParamQuery([Prefix 'AdjustC'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', ['Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.'], 1,'Fontsiz', 8);
Tol = ParamQuery([Prefix 'FreqTolMode'], 'acuity:', '', {'economic' 'exact'}, '', [ ...
    'Exact: no rounding applied;', char(10), 'Economic: allow slight (<1 part per 1000), memory-saving rounding of frequency shifts;'], ...
    1, 'Fontsiz', 8);

PhasePanel = add(PhasePanel, StartC);
PhasePanel = add(PhasePanel, StepC, below(StartC));
PhasePanel = add(PhasePanel, EndC, below(StepC));
PhasePanel = add(PhasePanel, AdjustC, nextto(StepC), [10 0]);
if ~isequal('notol', Flag),
    PhasePanel = add(PhasePanel, Tol, alignedwith(AdjustC) , [0 -10]);
end
