function [ C ] = EvalSCHR( figh,Prefix,P)
%EvalSCHR - compute phase shift series from PhaseSCHR panel GUI
%   Freq=EvalSCHR(figh) reads phase panel specs
%   from paramqueries StartC, StepC, EndC, AdjustC,
%   in the GUI figure with handle figh (see PhaseSCHR), and converts
%   them to the individual phase shift speeds.
%   Any errors in the user-specified values results in an empty return 
%   value Freq, while an error message is displayed by GUImessage.
%
%   In addition to the checks of EvalSCHR, this function also
%   checks if the flip frequencies are in the supplied noise spectrum.
%
%   EvalSCHR(figh, 'Foo') uses prefix Foo for the query names,
%   i.e., FooStartFreq, etc. The prefix defaults to ''.
%
%   EvalSCHR(figh, Prefix, P) does not read the queries, but
%   extracts them from struct P which was previously returned by GUIval.
%   This is the preferred use of EvalFrequencyStepper, because it leaves
%   the task of reading the parameters to the generic GUIval function. The
%   first input arg figh is still needed for error reporting.
%
%   See StimGUI, PhaseSCHR, GUIval, GUImessage.

if nargin<2, Prefix=''; end
if nargin<3, P = []; end
C = []; % allow premature return

if isempty(P), % obtain info from GUI. Non-preferred method; see help text.
    EXP = getGUIdata(figh,'Experiment');
    Q = getGUIdata(figh,'Query');
    StartC = read(Q([Prefix 'StartC']));
    [StepC, StepCUnit] = read(Q([Prefix 'StepC']));
    EndC = read(Q([Prefix 'EndC']));
    AdjustC = read(Q([Prefix 'AdjustC']));
    P = collectInstruct(StartC, StepC, StepCUnit, EndC, AdjustC);
else,
    P = dePrefix(P, Prefix);
    EXP = P.Experiment;
end

% check if stimulus frequencies are within range [CT.minFreq CT.maxFreq]
somethingwrong=1;
if (P.StartC<-1 || P.EndC>1)
    GUImessage(figh, 'C must be larger then -1 and smaller then 1', 'error', {'Cphase'});
    error('C must be larger then -1 and smaller then 1');
else, % passed all the tests..
    somethingwrong=0;
end
if somethingwrong, return; end

% delegate the computation to generic EvalStepper
StepMode = P.StepCUnit;
if isequal('Hz/s', StepMode), StepMode = 'Linear'; end

[C, Mess]=EvalStepper(P.StartC, P.StepC, P.EndC, StepMode, ...
    P.AdjustC, [-1 1]);
if isequal('nofit', Mess),
    Mess = {'Stepsize does not exactly fit Phase Shift Speed bounds', ...
        'Adjust Phase Shift speed parameters or toggle Adjust button.'};
elseif isequal('largestep', Mess)
    Mess = 'Step size exceeds C range';
elseif isequal('cripple', Mess)
    Mess = 'Different # C steps in the two DA channels';
elseif isequal('toomany', Mess)
    Mess = {['Too many (>' num2str(EXP.maxNcond) ') C steps.'] 'Increase stepsize or decrease range'};
end
GUImessage(figh,Mess, 'error',{[Prefix 'StartC'] [Prefix 'StepC'] [Prefix 'EndC'] });

if strcmpi(P.AddNoise,'yes')
    if P.NoiseLowFreq > P.NoiseHighFreq
        GUImessage(figh, 'The Low Freq of the noise must be lower then the high Freq of the noise.', ...
            'error', {'NoiseLowFreq' 'NoiseHighFreq'});
        error('The Low Freq of the noise must be lower then the high Freq of the noise.');
    end
end

if P.NoiseSPL <= 0
     GUImessage(figh, 'The Noise SPL must be larger then zero.', ...
            'error', {'NoiseSPL'});
     error('The Noise SPL must be larger then zero.');   
end

% if P.DistortionSPL <= 0
%      GUImessage(figh, 'The Noise SPL must be larger then zero.', ...
%             'error', {'DistortionSPL'});
%      error('The Noise SPL must be larger then zero.');   
% end

if isnan(P.NoiseSeed)
    P.NoiseSeed = round(rand(1,1)*1e6);
end

end

