function [ex_data,NR]=get_ex_data_MRNS(n,paths,bin_size)
% [ex_data]=get_ex_data_SHEnC_IC(n,paths,bin_size)
% ------------------------------------------------------------------------%
% Author: Monzilur Rahman
%
% USAGE: [ex_data]=get_ex_data_SHEnC_IC(n,paths,bin_size)
%
% this function creates the cochleagram from sound files and calculates the
% psth of neural responses
%
% Input parameters:
% n -- index number in neuronlist file
% paths -- 
%     location_of_neuronlist = paths.location_of_neuronlist;
%     location_of_sound_files = paths.location_of_sound_files;
%     neuronlist_file = paths.neuronlist_file;
%     data_folder = paths.data_folder;
% bin_size -- bin size
% 
% Output:
% ex_data -- a structure having two elements, one containing combined 
% stimuli and mean psth (combo), and another containing the psth of each
% single trial (r_combo)
%
% ----------------------------------------------------------------------- %
% get the neural response for 1 neuron
% neural responses are saved in files in a structure called data

% load data
location_of_SHEnC_summary = paths.location_of_SHEnC_summary;
location_of_stimuli = paths.location_of_stimuli;
neuronlist = paths.neuronlist;
data_folder = paths.data_folder;

neuron_file=strcat(data_folder,neuronlist{n});
load(neuron_file);

%number_of_sound_stimuli = size(data.set,2);
number_of_sound_stimuli = 45;
number_of_repeats_in_recordings = 14;
numBatch = 5;
numStimPerBatch = 9;
% calculate the number of repeats of each natural sound stimulus

% if no stimulus has got less than a set number of repeats make run the
% subsequenct steps of data processing
% create stimuli
scaling_constant=0;
i=1;
for batch=1:numBatch
    file_name = [location_of_stimuli,'MRNS_batch_',num2str(batch),'.wav'];
    [x,fs] = audioread(file_name);
    SamplePerStim = fs*4; % Each stimulus is 4s
    for stimID = 1:numStimPerBatch
        indStart = 1 + SamplePerStim*(stimID-1);
        indEnd = indStart + SamplePerStim -1;
%         sound(x,fs);
%         disp(i);
%         pause(5.5);
        [stim{i,1},t]=cochleagram(x(indStart:indEnd),fs,bin_size,'log');
        stimuli{i,1} = (stim{i,1}(:,:)-mean(stim{i,1}(:)))/std(stim{i,1}(:));
        i=i+1;
    end
end

%     % to plot the stimuli
%     for i=1:number_of_sound_stimuli;
%     subplot(5,8,i);
%     imagesc(stimuli{i});
%     end
% ------------------------------------------------------------- %

% number_of_sound_stimuli = size(data.set,2);

% calculate psth
combo=cell(number_of_sound_stimuli,1);
F = size(stimuli{1},1); % number of frequencies

% find the length of longest sound stimuli

t=t*1000;

for k=1:number_of_sound_stimuli
    %number_of_repeats_in_recordings = size(data.set(l).repeats,2);

    spiketimes = data.set(k).spikes.t;

    psth = histc(spiketimes,t);

    response(k,:) = psth/number_of_repeats_in_recordings; % spiking rates for 5ms bins

    combo{k,1} = zeros(F+1,size(response,2));

    % stimuli and neural responses combined in a cell array
    combo{k,1}(1:F,1:size(stimuli{1,1},2))=stimuli{k,1};
    combo{k,1}(F+1,:)=response(k,:);
    clear spiketimes;
    clear psth;
end

for k=1:number_of_sound_stimuli
    %number_of_repeats_in_recordings = size(data.set(l).repeats,2);
    time_length_of_sound = data.set(k).length_signal_ms;

    for i=1:number_of_repeats_in_recordings
        spiketimes = data.set(k).repeats(i).t;
        r_psth(i,:) = histc(spiketimes,t);
    end
    r{k,1} = r_psth;
    clear r_psth;
end

NR = calc_NR(cat(2,r{:}));
ex_data.combo=combo;
ex_data.r_combo=r;
ex_data.t=t;

end
