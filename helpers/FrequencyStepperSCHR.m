function Fsweep=FrequencyStepperSCHR(T, EXP, Prefix, Flag, Flag2);
% FrequencyStepperARMIN - generic frequency stepper panel for stimulus GUIs.
%   F=FrequencyStepperARMIN(Title, EXP) returns a GUIpanel F allowing the 
%   user to specify a series of frequencies, using either be logarithmic or
%   linear spacing.  The Guipanel F has title Title. EXP is the experiment 
%   definition, from which the number of DAC channels used (1 or 2) is
%   determined.
%
%   The paramQuery objects contained in F are named: 
%         StartFreq: starting frequency in Hz
%     StepFrequency: step in Hz or Octaves (toggle unit)
%      EndFrequency: end frequency in Hz
%        AdjustFreq: toggle selecting which of the above params to adjust
%                    in case StepFrequency does not fit exactly.
%       FreqTolMode: toggle selecting whether frequencies should be
%                    realized exactly, or whether memory-saving rounding is
%                    allowed.
%       LowPolarity: the sign of the correlation below the flip frequency
%          CorrUnit: the varied channel (I/C), of which part of the
%                    spectrum is modified
%
%   FrequencyStepperARMIN is a helper function for stimulus generators like 
%   makestimARMIN.
% 
%   F=FrequencyStepperARMIN(Title, ChanSpec, Prefix) prepends the string Prefix
%   to the paramQuery names, e.g. StartFreq -> ModStartFreq, etc.
%
%   Use EvalFrequencyStepperARMIN to read the values from the queries and to
%   compute the actual frequencies specified by the above step parameters.
%
%   See StimGUI, GUIpanel, EvalFrequencyStepperARMIN, makestimARMIN.

[Prefix, Flag, Flag2] = arginDefaults('Prefix/Flag/Flag2', '');

% # DAC channels and Flag2 determines the allowed multiplicity of user-specied numbers
if isequal('Both', EXP.AudioChannelsUsed) && ~isequal('nobinaural', Flag2), 
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

%==========frequency GUIpanel=====================
Fsweep = GUIpanel('Fsweep', T);
TypePanel = ParamQuery([Prefix 'TypePanel'], 'Panel Type:', '', {'F0' 'Harmonic Number'}, ...
    '', ['Choose how you want to introduce the data.'], 1,'Fontsiz', 11);
StartFreq = ParamQuery([Prefix 'StartFreq'], 'Start:', '15000.5 15000.5', 'Hz or #', ...
    'rreal/positive', ['Starting frequency of series. If type of panel chosen is Harmonics Number, it is equal to starting CF/F0' PairStr], Nchan);
StepFreq = ParamQuery([Prefix 'StepFreq'], 'Step:', '12000', 'Hz or #', ...
    'rreal/positive', ['Frequency step of series. If type of panel chosen is Harmonics Number, it is equal to step CF/F0.' PairStr], Nchan);
EndFreq = ParamQuery([Prefix 'EndFreq'], 'End:', '12000.1 12000.1', 'Hz or #', ...
    'rreal/positive', ['Last frequency of series. If type of panel chosen is Harmonics Number, it is equal to end CF/F0' PairStr], Nchan);
AdjustFreq = ParamQuery([Prefix 'AdjustFreq'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', ['Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.'], 1,'Fontsiz', 8);
Tol = ParamQuery([Prefix 'FreqTolMode'], 'acuity:', '', {'economic' 'exact'}, '', [ ...
    'Exact: no rounding applied;', char(10), 'Economic: allow slight (<1 part per 1000), memory-saving rounding of frequencies;'], ...
    1, 'Fontsiz', 8);
FreqHighest = ParamQuery('FreqHigh', 'HighFreq:', '1000', 'Hz', ...
    'rreal/positive', 'Highest Frequency in the stimulus.');
FreqLowest = ParamQuery('FreqLow', 'LowFreq:', '1000', 'Hz', ...
    'rreal/positive', 'Lowest Frequency in the stimulus.');
HarLowest = ParamQuery('HarLow', 'Lowest Har:', '2', '#', ...
    'rreal','Lowest Harmonic in the stimulus.');
HarHighest = ParamQuery('HarHigh', 'Highest Har:', '20', '#', ...
    'rreal','Highest Harmonic in the stimulus.');
CF = ParamQuery('CF', 'CF:', '1200', 'Hz','rreal', 'Only used when type of panel chosen is Harmonics Number.');

Fsweep = add(Fsweep, TypePanel);
Fsweep = add(Fsweep, StartFreq,below(TypePanel));
Fsweep = add(Fsweep, StepFreq, alignedwith(StartFreq));
Fsweep = add(Fsweep, EndFreq, alignedwith(StepFreq));
Fsweep = add(Fsweep, AdjustFreq, nextto(StepFreq), [10 0]);
Fsweep = add(Fsweep, HarLowest, below(EndFreq), [0 2]);
Fsweep = add(Fsweep, HarHighest, nextto(HarLowest), [10 0]);
Fsweep = add(Fsweep, FreqLowest, below(HarLowest), [0 2]);
Fsweep = add(Fsweep, FreqHighest, nextto(FreqLowest), [10 0]);
Fsweep = add(Fsweep, CF, below(FreqLowest), [0 2]);



 
if ~isequal('notol', Flag),
    Fsweep = add(Fsweep, Tol, alignedwith(AdjustFreq) , [0 -10]);
end





