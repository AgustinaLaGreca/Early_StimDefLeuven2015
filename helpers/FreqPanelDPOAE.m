function freqPanel=FreqPanelDPOAE(T, EXP, Prefix, CmpName);
% Panel for simple frequency selection 
% 

[Prefix, CmpName] = arginDefaults('Prefix/CmpName', '', 'Title');

if isequal('-',T), T = 'F1 and F2'; end

DACstr = getDACstr(EXP.AudioChannelsUsed, EXP.Recordingside);
ClickStr = ' Click button to select ';
    
% Freq1 = ParamQuery([Prefix 'F1'], 'Frequency 1 (L):', '15000.5', 'Hz', ...
%     'rreal/positive', [CmpName ' Frequency'], 1);

StartFreq = ParamQuery([Prefix 'StartFreq'], 'F1 Start (L)  :', '15000.5', 'Hz', ...
    'rreal/positive', 'F1, played on the Left', 1);
StepFreq = ParamQuery([Prefix 'StepFreq'], 'F1 Step (L)  :', '12000', {'Hz' 'Octave'}, ...
    'rreal/positive', ['Frequency step of series.' ClickStr 'step units.'], 1);
EndFreq = ParamQuery([Prefix 'EndFreq'], 'F1 End (L)  :', '15000.5', 'Hz', ...
    'rreal/positive', 'F1, played on the Left', 1);
AdjustFreq = ParamQuery([Prefix 'AdjustFreq'], 'adjust:', '', {'none' 'start' 'step' 'end'}, ...
    '', ['Choose which parameter to adjust when the stepsize does not exactly fit the start & end values.'], 1,'Fontsiz', 8);
Tol = ParamQuery([Prefix 'FreqTolMode'], 'acuity:', '', {'economic' 'exact'}, '', [ ...
    'Exact: no rounding applied;', char(10), 'Economic: allow slight (<1 part per 1000), memory-saving rounding of frequencies;'], ...
    1, 'Fontsiz', 8);
Ratio = ParamQuery([Prefix 'Ratio'], 'Ratio (F2/F1)     ::', '1.50', '', ...
    'rreal/positive', 'Ratio determines F2', 1);


% RatioEnd = ParamQuery([Prefix 'RatioEnd'], 'Ratio (F2/F1)     ::', '1.50', '', ...
%     'rreal/positive', 'Ratio determines F2', 1);
% RatioSteps = ParamQuery([Prefix 'RatioSteps'], 'Stepping for ratio:', '1.50', '', ...
%     'rreal/positive', 'Ratio determines F1. ', 1);
% RatioBegin=messenger([Prefix 'RatioBegin'], ':1',1);

Freq2=messenger([Prefix 'F2Msg'], 'Frequency 2 (R)  : [******] Hz to [*******] Hz ',2);
DAC = ParamQuery([Prefix 'DAC'], 'DAC:', '', DACstr, '', [ ...
    'F1 and F2 are played on Left/Right (or)', char(10), 'F1 played on Left and F2 on Right'], ...
    1);

freqPanel = GUIpanel('Title', T);
freqPanel = add(freqPanel,StartFreq,'below');
freqPanel = add(freqPanel,StepFreq,'below');
freqPanel = add(freqPanel,EndFreq,'below');
freqPanel = add(freqPanel,Tol,'nextto',[10 -5]);
freqPanel = add(freqPanel,AdjustFreq,'below',[0 -8]);

% freqPanel = add(freqPanel,RatioEnd,below(Freq1));
% freqPanel = add(freqPanel,RatioBegin,'nextto',[0 9]);
% freqPanel = add(freqPanel,RatioSteps,below(RatioEnd));

freqPanel = add(freqPanel,Ratio,below(EndFreq), [0 10]);
freqPanel = add(freqPanel,Freq2,'below', [0 10]);
freqPanel = add(freqPanel,DAC,'below', [80 0]);

% freqPanel = add(freqPanel,DAC,'nextto',[15 0]);
% freqPanel = add(freqPanel,MaxSPL,['below ' Prefix 'SPL'],[17 0]);
freqPanel = marginalize(freqPanel, [0 3]);




