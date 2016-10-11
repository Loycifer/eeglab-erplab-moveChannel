% Function for moving channels

function EEGout = moveChannel(EEG, sourceChannel, destinationChannel)
    numberOfChannels = length(EEG.chanlocs);
    if (sourceChannel < destinationChannel)
        shift = 'up';
    else
        shift = 'down';
    end
    numberOfOperations = abs(sourceChannel - destinationChannel);
    operationArray = {['ch' num2str(numberOfChannels+1) ' = ch' num2str(sourceChannel)] };
    dummyLocation = EEG.chanlocs(sourceChannel);
    for i = 1:numberOfOperations
        if (strcmp(shift,'up'))
            targetChannel = sourceChannel + (i-1);
            operationArray(end+1) = {['ch' num2str(targetChannel) ' = ch' num2str(targetChannel+1)]};
            channelName = EEG.chanlocs(targetChannel).labels;
            EEG.chanlocs(targetChannel) = EEG.chanlocs(targetChannel+1);
            EEG.chanlocs(targetChannel).labels = channelName;
        else
            targetChannel = sourceChannel - (i-1);
            operationArray(end+1) = {['ch' num2str(targetChannel) ' = ch' num2str(targetChannel-1)]};
            channelName = EEG.chanlocs(targetChannel).labels;
            EEG.chanlocs(targetChannel) = EEG.chanlocs(targetChannel-1);
            EEG.chanlocs(targetChannel).labels = channelName;
        end 
    end
    operationArray(end+1) = {['ch' num2str(destinationChannel) ' = ch' num2str(numberOfChannels+1)]};
    channelName = EEG.chanlocs(destinationChannel).labels;
    EEG.chanlocs(destinationChannel) = dummyLocation;
    EEG.chanlocs(destinationChannel).labels = channelName;
    operationArray(end+1) =  {['ch' num2str(numberOfChannels+1) ' = ch' num2str(numberOfChannels+1) ' label REMOVE']}
    %EEGout = operationArray;
    EEG = pop_eegchanoperator( EEG, operationArray, 'ErrorMsg', 'popup');
    EEG = pop_select( EEG,'nochannel',{'REMOVE'});
    EEGout = EEG;
    eeglab redraw;
end

