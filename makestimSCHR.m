function P2=makestimSCHR(P);
% MakestimARMIN - stimulus generator for ARMIN stimGUI
%    P=MakestimARMIN(P), where P is returned by GUIval, generates the stimulus
%    specified in P. MakestimARMIN is typically called by StimGuiAction when
%    the user pushes the Check, Play or PlayRec button.
%    MakestimARMIN does the following:
%        * Complete check of the stimulus parameters and their mutual
%          consistency, while reporting any errors
%        * Compute the stimulus waveforms
%        * Computation and broadcasting info about # conditions, total
%          stimulus duration, Max SPL, etc.
%
%    MakestimARMIN renders P ready for D/A conversion by adding the following 
%    fields to P
%            Fsam: sample rate [Hz] of all waveforms. This value is
%                  determined by carrier & modulation freqs, but also by
%                  the Experiment definition P.Experiment, which may 
%                  prescribe a minimum sample rate needed for ADC.
%            Fcar: carrier frequencies [Hz] of all the presentations in an
%                  Nx2 matrix or column array
%        Waveform: Waveform object array containing the samples in SeqPlay
%                  format.
%     Attenuation: scaling factors and analog attuater settings for D/A
%    Presentation: struct containing detailed info on stimulus order,
%                  broadcasting of D/A progress, etc.
% 
%   See also noiseStim, Waveform/maxSPL, Waveform/play, sortConditions


P2 = []; % a premature return will result in []
if isempty(P), return; end
figh = P.handle.GUIfig;

% check & convert params. Note that helpers like evalfrequencyStepper
% report any problems to the GUI and return [] or false in case of problems.


P.Fcar=EvalFrequencyStepperSCHR(figh, '', P); 
if strcmp(P.TypePanel,'F0')
invalid = P.HarLow*P.Fcar > P.FreqHigh;
if invalid
    Mess = {['Specified lowest harmonic number ' num2str(P.HarLow) ' of fundamental frequencies ' num2str(P.Fcar(invalid)') 'Hz' ' is greater than specified highest frequency limit ' num2str(P.FreqHigh) 'Hz.'],...
        'Increase highest frequency limit or decrease lowest harmonic number or change range of studied fundamental frequencies '};
    GUImessage(figh, Mess, 'error', {'HarLow' 'FreqHigh' 'StartFreq' 'StepFreq' 'EndFreq'});
end
end
if isempty(P.Fcar), return; end
Ncond = size(P.Fcar,1); % # conditions

P.WavePhase = 0;

P.C = EvalSCHR(figh,'',P);
if isempty(P.C), return; end

% split ITD in different types
[P.FineITD, P.GateITD, P.ModITD] = ITDparse(P.ITD, P.ITDtype);

% no heterodyning for this protocol
[P.IFD, P.IPD] = deal(0); % zero interaural frequency difference



% mix Freq & SPL sweeps; # conditions = # Freqs times # Phase shift speed C. By
% convention, freq is updated faster. 
[P.Fcar, P.C, P.Ncond_XY] = MixSweeps(P.Fcar, P.C);
maxNcond = P.Experiment.maxNcond;
if prod(P.Ncond_XY)>maxNcond,
    Mess = {['Too many (>' num2str(maxNcond) ') stimulus conditions.'],...
        'Increase stepsize(s) or decrease range(s)'};
    GUImessage(figh, Mess, 'error', {'StartFreq' 'StepFreq' 'EndFreq' 'StartC' 'StepC' 'EndC' });
end

% Process visiting order of stimulus conditions
VisitOrder = EvalPresentationPanel_XY(figh, P, P.Ncond_XY);
if isempty(VisitOrder), return; end

% Durations & PlayTime messenger
okay=EvalDurPanel(figh, P, P.Ncond_XY);
if ~okay, return; end



% Determine sample rate and actually generate the calibrated waveforms
P = SCHRStim(P); % P contains both Experiment (calib etc) & params, including P.Fcar 

% Sort conditions, add baseline waveforms (!), provide info on varied parameter etc
P = sortConditions(P, {'Fcar' 'C'}, {'Carrier frequency' 'Carrier Intensity'}, ...
    {'Hz' 'rad'}, {'Hz' 'Linear'});

% Levels and active channels (must be called *after* adding the baseline waveforms)
[mxSPL P.Attenuation] = maxSPL(P.Waveform, P.Experiment);
okay = CheckSPL(figh, P.SPL, mxSPL, P.Fcar, '', {'StartSPL' 'EndSPL'});
if ~okay, return; end

% Summary
ReportSummary(figh, P);

% everything okay: return P
P2=P;

