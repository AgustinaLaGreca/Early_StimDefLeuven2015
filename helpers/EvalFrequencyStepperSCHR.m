function Freq=EvalFrequencyStepperSCHR(figh, Prefix, P);
% EvalFrequencyStepper - compute frequency series from Frequency stepper GUI
%   Freq=EvalFrequencyStepper(figh) reads frequency-stepper specs
%   from paramqueries StartFreq, StepFrequency, EndFrequency, AdjustFreq,
%   in the GUI figure with handle figh (see FrequencyStepper), and converts
%   them to the individual frequencies of the frequency-stepping series.
%   Any errors in the user-specified values results in an empty return 
%   value Freq, while an error message is displayed by GUImessage.
%
%   In addition to the checks of EvalFrequencyStepper, this function also
%   checks if the flip frequencies are in the supplied noise spectrum.
%
%   EvalFrequencyStepper(figh, 'Foo') uses prefix Foo for the query names,
%   i.e., FooStartFreq, etc. The prefix defaults to ''.
%
%   EvalFrequencyStepper(figh, Prefix, P) does not read the queries, but
%   extracts them from struct P which was previously returned by GUIval.
%   This is the preferred use of EvalFrequencyStepper, because it leaves
%   the task of reading the parameters to the generic GUIval function. The
%   first input arg figh is still needed for error reporting.
%
%   See StimGUI, FrequencyStepper, GUIval, GUImessage.

if nargin<2, Prefix=''; end
if nargin<3, P = []; end
Freq = []; % allow premature return

if isempty(P), % obtain info from GUI. Non-preferred method; see help text.
    EXP = getGUIdata(figh,'Experiment');
    Q = getGUIdata(figh,'Query');
    TypePanel = read(Q([Prefix 'TypePanel']));
    StartFreq = read(Q([Prefix 'StartFreq']));
    [StepFreq, StepFreqUnit] = read(Q([Prefix 'StepFreq']));
    EndFreq = read(Q([Prefix 'EndFreq']));
    AdjustFreq = read(Q([Prefix 'AdjustFreq']));
    FreqHigh = read(Q([Prefix 'FreqHighest']));
    FreqLow = read(Q([Prefix 'FreqLowest']));
    HarLow = read(Q([Prefix 'HarLowest']));
    HarHigh = read(Q([Prefix 'HarHighest']));
    CF = read(Q([Prefix 'CF']));
    P = collectInstruct(StartFreq, StepFreq, StepFreqUnit, EndFreq, AdjustFreq,FreqHigh, FreqLow, HarLow, HarHigh, CF);
else,
    P = dePrefix(P, Prefix);
    EXP = P.Experiment;
end

% check if stimulus frequencies are within range [CT.minFreq CT.maxFreq]
somethingwrong=1;

% Edits by Gowtham 31-10-19
% 1. Since the option to switch between F0 and Harmonics was removed, the
%    below code is altered accordingly
% 2. (As directed by Pxj) The code was altered to allow Starting and Ending 
%    Frequencies of fundamental frequencies beyond EXP's calibartated frequency range. 
%    Instead the Lowest and Highest Frequencies are checked.

% if strcmp(P.TypePanel,'F0')

    if any(P.FreqLow<EXP.minStimFreq) ,
        GUImessage(figh, {'Lowest frequency violates min stim frequency'...
            ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', [Prefix 'FreqLow']);
    elseif any(P.FreqHigh<EXP.minStimFreq) ,
        GUImessage(figh, {'Highest frequency violates min stim frequency'...
            ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', [Prefix 'FreqHigh']);
    elseif any(P.FreqLow>EXP.maxStimFreq) ,
        GUImessage(figh, {'Lowest frequency exceeds max stim frequency'...
            ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', [Prefix 'FreqLow']);
    elseif any(P.FreqHigh>EXP.maxStimFreq) ,
        GUImessage(figh, {'Highest frequency exceeds max stim frequency'...
            ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', [Prefix 'FreqHigh']);
    else, % passed all the tests..
        somethingwrong=0;
    end
    if somethingwrong, return; end

% else
%     if any(P.CF/P.StartFreq<EXP.minStimFreq),
%         GUImessage(figh, {'Start frequency violates min stim frequency'...
%             ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', [Prefix 'StartFreq']);
%     elseif any(P.CF/P.EndFreq<EXP.minStimFreq),
%         GUImessage(figh, {'End frequency violates min stim frequency'...
%             ['of ' num2str(EXP.minStimFreq) ' Hz']},'error', [Prefix 'EndFreq']);
%     elseif  any(P.CF/P.StartFreq>EXP.maxStimFreq),
%         GUImessage(figh, {'Start frequency exceeds max stim frequency'...
%             ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', [Prefix 'StartFreq']);
%     elseif any(P.CF/P.EndFreq>EXP.maxStimFreq),
%         GUImessage(figh, {'End frequency exceeds max stim frequency'...
%             ['of ' num2str(EXP.maxStimFreq) ' Hz']},'error', [Prefix 'EndFreq']);
%     else, % passed all the tests..
%         somethingwrong=0;
%     end
%     if somethingwrong, return; end
% end

% delegate the computation to generic EvalStepper
StepMode = P.StepFreqUnit;
if isequal('Hz', StepMode), StepMode = 'Linear'; end

% if strcmp(P.TypePanel,'Harmonic Number')
%     [Freq, Mess]=EvalStepperHarmonics(P.CF,P.StartFreq,P.StepFreq, P.EndFreq, StepMode, ...
%     P.AdjustFreq, [EXP.minStimFreq EXP.maxStimFreq], EXP.maxNcond);
% else
    [Freq, Mess]=EvalStepper(P.StartFreq, P.StepFreq, P.EndFreq, StepMode, ...
    P.AdjustFreq, [P.StartFreq P.EndFreq], EXP.maxNcond);
% end
if isequal('nofit', Mess),
    Mess = {'Stepsize does not exactly fit Frequency bounds', ...
        'Adjust Frequency parameters or toggle Adjust button.'};
elseif isequal('largestep', Mess)
    Mess = 'Step size exceeds frequency range';
elseif isequal('cripple', Mess)
    Mess = 'Different # frequency steps in the two DA channels';
elseif isequal('toomany', Mess)
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') frequency steps.'] 'Increase stepsize or decrease range'};
end
GUImessage(figh,Mess, 'error',{[Prefix 'StartFreq'] [Prefix 'StepFreq'] [Prefix 'EndFreq'] });


