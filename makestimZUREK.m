function P2=makestimZUREK(P);
% makestimZUREK - stimulus generator for ZUREK stimGUI
%    P=MakestimZUREK(P), where P is returned by GUIval, generates the stimulus
%    specified in P. MakestimITD is typically called by StimGuiAction when
%    the user pushes the Check, Play or PlayRec button.
%    MakestimDIZON does the following:
%        * Complete check of the stimulus parameters and their mutual
%          consistency, while reporting any errors
%        * Compute the stimulus waveforms
%        * Computation and broadcasting info about # conditions, total
%          stimulus duration, Max SPL, etc.
%
%    MakestimZUREK renders P ready for D/A conversion by adding the following 
%    fields to P
%            Fsam: sample rate [Hz] of all waveforms. This value is
%                  determined by the stimulus spectrum, but also by
%                  the Experiment definition P.Experiment, which may 
%                  prescribe a minimum sample rate needed for ADC.
%           Phase: column array of phases realizing the phase steps.
%        Waveform: Waveform object array containing the samples in SeqPlay
%                  format.
%     Attenuation: scaling factors and analog attuater settings for D/A
%    Presentation: struct containing detailed info on stimulus order,
%                  broadcasting of D/A progress, etc.
% 
%   See also stimdefZUREK.
% 
%   Created by Gowtham Aug 2020

P2 = []; % a premature return will result in []
if isempty(P), return; end
figh = P.handle.GUIfig;

% To decide on dB SPL or dB/Hz
P.echoSPLUnit = P.SPLUnit;
P.ILDUnit = P.SPLUnit;
P.echoILDUnit = P.SPLUnit;

% if ~(strcmp(P.echoILDUnit,P.ILDUnit)&&strcmp(P.echoSPLUnit,P.SPLUnit)&&strcmp(P.echoSPLUnit,P.echoILDUnit))
%     Mess = {['The units of SPL and ILD should be the same for both Echo and Source']};
%     GUImessage(figh, Mess, 'error', {'SPLUnit','echoSPLUnit','echoILDUnit','ILDUnit' });
%     return;
% end

% check & convert params. Note that helpers like evalphaseStepper
% report any problems to the GUI and return [] or false in case of
% problems.

% Noise parameters (SPL cannot be checked yet)
[okay, ~,P] = EvalNoisePanel(figh, P);
if ~okay, return; end
 
% if P.DAC(1)=='L'||P.DAC(1)=='R',
%     Mess = {['The stimulus is binaural'],...
%         'Change the experiment settings to binaural'};
%     GUImessage(figh, Mess, 'error', {'DAC' });
%     return;
% end

% no heterodyning for this protocol
P.IFD = 0; % zero interaural frequency difference

% Noise parameters (SPL cannot be checked yet)
[okay, P.NoiseSeed] = EvalNoisePanel(figh, P);
if ~okay, return; end

% Phase: add it to stimparam struct P
P.ITD=EvalITDstepper(figh, P); 
if isempty(P.ITD), return; end
Ncond = numel(P.ITD);

% No advanced duration settings
P.WavePhase = 0;

% Durations & PlayTime; this also parses ITD/ITDtype and adds ...
[okay, P]=EvalDurPanelZUREK(figh, P, Ncond);% ... FineITD, GateITD, ModITD fields to P
if ~okay, return; end

[P.ModFreq, P.ModDepth, P.ModStartPhase, P.ModTheta, P.IPD] = deal(0);

% Determine sample rate and actually generate the calibrated waveforms
P = noiseStimZUREK(P); % P contains both Experiment (calib etc) & params, including P.Fcar 

% Sort conditions, add baseline waveforms (!), provide info on varied parameter etc
P = sortConditions(P, 'ITD', 'ITD', 'ms', 'lin');

% Levels and active channels (must be called *after* adding the baseline waveforms)
[mxSPL P.Attenuation] = maxSPL(P.Waveform, P.Experiment);
okay=EvalSPLpanelZUREK(figh,P, mxSPL, []);
if ~okay, return; end

% Summary
ReportSummary(figh, P);

P2=P;








