function ReportSummary(figh, P);
% ReportSummary - compute total play time and report it to Summary panel 
%     T=ReportSummary(figh, Ncond, Nrep, ISI, totBaseline) computes total 
%     play time T (in seconds) from the number of conditions Ncond, the number of 
%     reps Nrep, the inter-stimulus-interval ISI (in ms) and the sum of
%     pre- and post-stimulus baselines, totBaseline. ReportSummary reports
%     T to the Summary messenger of the stimulus GUI having handle figh.
%
%     ReportSummary(figh, nan) resets the string of the Summary messenger 
%     to its TestLine value (see Messenger).
%
%     [T, Tstr]=ReportSummary(figh, ...) also returns the string
%     displayed in the Summary panel.
%
%   
%   See StimGUI, DurPanel, Summary, makestimFS, Messenger.

% remove duplicates because of repetitions
iCond = P.Presentation.iCond;
[~, I, ~] = unique(iCond,'first');
iCond = iCond(sort(I));

x = P.Presentation.x;
y = P.Presentation.Y;
    
Tstr = ['-- F2 ------------------ L1 -------------- \n'];

Tstr=[Tstr,tablePrint(P.DAC,iCond,P.(x.FieldName),P.(y.FieldName),P.F1)];

% report
M = GUImessenger(figh, 'Summary');
report(M,sprintf(Tstr));
end

function Tstr=tablePrint(DAC,iCond,xValues,yValues,F1)
[k, l] = size(xValues);
xValues = sortValues(xValues,iCond);
yValues = sortValues(yValues,iCond);

Tstr = '';

% Very ugly way to align all numbers correctly
for i=1:k+2
    
        leftString = addPadding(num2str(xValues(i,1),5),14);
        rightString = addPadding(num2str(yValues(i,2),5),13);

    if ~isempty(strfind(leftString,'NaN')) || ~isempty(strfind(rightString,'NaN'))
        leftString = '                    BASELINE';
        rightString = '';
    end
    % Append leftmost string
    Tstr = [Tstr,leftString];
    
    Tstr = [Tstr,'   '];
    
    % Append rightmost string
    Tstr = [Tstr,rightString,'\n'];
end
end

function Tstr=addPadding(Tstr,totalLength)
    % Add spaces for alignment
    for j=0:(totalLength-length(Tstr))
        Tstr=[Tstr,'  '];
    end
    % Add one extra space if leftmost string contains dot
    if ~isempty(strfind(Tstr,'.'))
        Tstr=[Tstr,' '];
    end
end

function values=sortValues(values,iCond)
[k, l] = size(values);
% Expand when only one channel
if l==1
    values(:,2) = values(:,1);
end

% Sort by iCond
values(k+1:k+2,:) = NaN;
values = values(iCond,:);
end