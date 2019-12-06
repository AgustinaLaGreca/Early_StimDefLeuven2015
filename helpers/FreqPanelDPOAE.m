function freqPanel=FreqPanelDPOAE(T, EXP, Prefix, CmpName);
% Panel for simple frequency selection 
% 

[Prefix, CmpName] = arginDefaults('Prefix/CmpName', '', 'Title');

if isequal('-',T), T = 'F1 and F2'; end

% Freq1 = ParamQuery([Prefix 'F1'], 'Frequency 1 (L):', '15000.5', 'Hz', ...
%     'rreal/positive', [CmpName ' Frequency'], 1);

Freq1 = ParamQuery([Prefix 'F1'], 'Frequency 1 (L)  :', '15000.5', 'Hz', ...
    'rreal/positive', 'F2', 1);

RatioEnd = ParamQuery([Prefix 'RatioEnd'], 'Ratio (F2/F2)     ::', '1.50', '', ...
    'rreal/positive', 'Ratio determines F2', 1);
RatioSteps = ParamQuery([Prefix 'RatioSteps'], 'Stepping for ratio:', '1.50', '', ...
    'rreal/positive', 'Ratio determines F1. ', 1);
RatioBegin=messenger([Prefix 'RatioBegin'], ':1',1);

Freq2=messenger([Prefix 'F2Msg'], 'Frequency 2 (L)  : [******] Hz to [*******] Hz ',2);
Tol = ParamQuery([Prefix 'FreqTolMode'], 'acuity:', '', {'economic' 'exact'}, '', [ ...
    'Exact: no rounding applied;', char(10), 'Economic: allow slight (<1 part per 1000), memory-saving rounding of frequencies;'], ...
    1, 'Fontsiz', 8);

freqPanel = GUIpanel('Title', T);
freqPanel = add(freqPanel,Freq1,'below');
freqPanel = add(freqPanel,RatioEnd,'below');
freqPanel = add(freqPanel,RatioBegin,'nextto',[0 9]);
freqPanel = add(freqPanel,RatioSteps,below(RatioEnd));
freqPanel = add(freqPanel,Freq2,'below');
freqPanel = add(freqPanel,Tol,below(Freq2));


% freqPanel = add(freqPanel,DAC,'nextto',[15 0]);
% freqPanel = add(freqPanel,MaxSPL,['below ' Prefix 'SPL'],[17 0]);
freqPanel = marginalize(freqPanel, [0 3]);




