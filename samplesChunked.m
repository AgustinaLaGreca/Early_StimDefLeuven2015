function NewSamples = samplesChunked(Samples,Nrep,SampleSize);
% Waveform/samples - chunks the samples from waveform object to make it work with Nrep
% 
%     [Y] = samplesChunked(W) gets a fully expanded and breaks it into
%     chunks. These chunks can be used with Nrep. 
%
%     Created by Gowtham 21/08/20 
%     (Lacked creative reserves to come up with a better name)

NewSamples = [];

    for ichunk=1:numel(Nrep),
        if(Nrep(ichunk)==1)
            chunk=Samples(1:SampleSize(ichunk));
            Samples(1:SampleSize(ichunk))=[];
        else
%             wholechunk = Samples(1:(SampleSize(ichunk)*Nrep(ichunk)));
%             wholechunk = reshape(wholechunk,Nrep(ichunk),[]);
%             chunk = mean(wholechunk)';
            chunk=Samples(1:SampleSize(ichunk));
            Samples(1:SampleSize(ichunk)*Nrep(ichunk))=[];
        end        
        NewSamples{ichunk} = chunk;
    end
 end
