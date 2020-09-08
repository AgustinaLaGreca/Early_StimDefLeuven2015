function VariedChanVsDAC(figh,DAC,VariedChan)
% When DAC is monaural, it checks if the varied ear is recorded and informs
% the user.
% By Gowtham 8/9/20

DAC=upper(DAC);
VariedChan=upper(VariedChan);

if ~strcmp(DAC(1),'B')
    if ~contains(DAC,VariedChan)    % Includes Right/Left and Ipsi/Contra
        GUImessage(figh,'DAC settings excludes varied ear', 'error', {['DAC']});
        YN = questdlg(['The varied ear is not recorded because DAC is ' DAC ...
            ' and varied channel is ' VariedChan '. Want to continue?'], 'Varied Channel vs DAC', 'Yes', 'No', 'Yes');
        if isequal('No', YN), 
            GUImessage(gcg, {'Stimcheck cancelled'});
            error('Stimcheck cancelled');
        end
    end
end