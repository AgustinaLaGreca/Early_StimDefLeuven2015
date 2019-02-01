function Amp=ClickAmpRefPanel(T)
% ClickAmpPanel - Amplitude reference option for click panels (CSPL, CFS,
% CTD)
%   S=ClickPanel(Title, EXP) returns a GUIpanel M allowing the 
%   user to specify how pulse amplitude value will be generated: by
%   specifying the SPL value, or by using the amplitude of the 100 Hz
%   refrence.
%
%   Title T.
%
%   The paramQuery objects contained in F are named: 
%         AmplitudeGen
%
%   ClickPanel is a helper function for stimulus definitions like stimdefCFS.
% 
%   M=ClickPanel(Title, EXP, Prefix) prepends the string Prefix
%   to the paramQuery names.
%   Default Prefix is '', i.e., no prefix.
%
%   Use EvalClickAmpRefPanel to read the values from the queries. -> To be
%   implemented if for example different frequency values
%
%   See StimGUI, GUIpanel, EvalClickAmpRefPanel, stimdefCFS, stimdefCTD.

Prefix = arginDefaults('Prefix', '');

Amp = GUIpanel('AmpRef', T);
AmpRef = ParamQuery([Prefix 'AmpRef'], ...
    'Amplitude ref:', '', {'SPL','100 Hz'}, '', ...
    'How pulse amplitude is obtained. SPL values are specified below.');

Amp = add(Amp,AmpRef);




