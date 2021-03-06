function P2=makestimENH_DB(P);


P2 = []; % a premature return will result in []
if isempty(P), return; end
figh = P.handle.GUIfig;



% SPL
SPL=EvalSPLstepper(figh, '', P); 

P.dBdiff = SPL;
if isempty(SPL), return; end



P.notchW = [-P.notchW;P.notchW];
% mix width & SPL sweeps; # conditions = # Freqs times # SPLs. By
% convention, freq is updated faster. 
[P.notchW, P.dBdiff, P.Ncond_XY] = MixSweeps(P.notchW, P.dBdiff);
maxNcond = P.Experiment.maxNcond;
if prod(P.Ncond_XY)>maxNcond,
    Mess = {['Too many (>' num2str(maxNcond) ') stimulus conditions.'],...
        'Increase stepsize(s) or decrease range(s)'};
    GUImessage(figh, Mess, 'error', {'StartW' 'StepW' 'EndW' 'StartSPL' 'StepSPL' 'EndSPL' });
    return;
end

% Process visiting order of stimulus conditions
VisitOrder = EvalPresentationPanel_XY(figh, P, P.Ncond_XY);
if isempty(VisitOrder), return; end

% Determine sample rate and actually generate the calibrated waveforms


P = enhancement_harmonicStim(P); % P contains both Experiment (calib etc) & params, including P.Fcar 

% Sort conditions, add baseline waveforms (!), provide info on varied parameter etc
P = sortConditions(P, {'notchW' 'dBdiff'}, {'Notch width' 'Components Intensity'}, ...
    {'Hz' 'dB SPL'}, {'' 'Linear'});

% Levels and active channels (must be called *after* adding the baseline waveforms)
[mxSPL, P.Attenuation] = maxSPL(P.Waveform, P.Experiment);

mxSPL
P.Attenuation.AnaAtten
P.Attenuation.NumGain_dB
P.Attenuation.NumScale

okay=EvalSPLpanel(figh,P, mxSPL, []);
if ~okay, return; end



% Summary
ReportSummary(figh, P);
P2=P;
