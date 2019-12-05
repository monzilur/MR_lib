function [ex_data]=get_ex_data(n,paths,bin_size)
% ------------------------------------------------------------------------%
% Author: Monzilur Rahman
%
% USAGE: [ex_data]=get_ex_data(n,paths,bin_size)
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
    
    location_of_neuronlist = paths.location_of_neuronlist;
    location_of_sound_files = paths.location_of_sound_files;
    neuronlist_file = paths.neuronlist_file;
    data_folder = paths.data_folder;
    
    load(strcat(location_of_neuronlist,neuronlist_file));
    neuron_file=strcat(data_folder,neuronlist{n});
    load(neuron_file);
    location_of_sound_files = paths.location_of_sound_files;
    number_of_sound_stimuli = size(data.set,2);
    
    % create stimuli
    scaling_constant=0;
    for i=1:number_of_sound_stimuli
        source = data.set(i).stim_params.Source;
        token = data.set(i).stim_params.Token;
        fw = data.set(i).stim_params.Set;
        frozen=data.set(i).stim_params.StimID;
        file_name = strcat(location_of_sound_files,'source.',...
            num2str(source),'.sound.0.snr.0.token.',num2str(token),...
            '.fw.',num2str(fw),'.frozen.',num2str(frozen));
        [x,fs] = audioread(file_name);
%         sound(x,fs);
%         disp(i);
%         pause(5.5);
        [stim{i,1},t,~]=cochleagram_zilany_AN(x,fs,bin_size,'log',2);
        stimuli{i,1} = (stim{i,1}(:,:)-mean(stim{i,1}(:)))/std(stim{i,1}(:));
    end

%     % to plot the stimuli
%     for i=1:number_of_sound_stimuli;
%     subplot(5,8,i);
%     imagesc(stimuli{i});
%     end
% ------------------------------------------------------------- %

% calculate psth
combo=cell(number_of_sound_stimuli,1);
F = size(stimuli{1},1); % number of frequencies

% find the length of longest sound stimuli

t=t*1000;
    
for k=1:number_of_sound_stimuli
    
    number_of_repeats_in_recordings = size(data.set(k).repeats,2);
    
    spiketimes = data.set(k).spikes.t;
    
    psth = histc(spiketimes,t);
    if isempty(psth)
        psth = zeros(size(psth,1),1);
    end
    response(k,:) = psth/number_of_repeats_in_recordings; % spiking rates for 5ms bins

    combo{k,1} = zeros(F+1,size(response,2));
    
    % stimuli and neural responses combined in a cell array
    combo{k,1}(1:F,1:size(stimuli{1,1},2))=stimuli{k,1};
    combo{k,1}(F+1,:)=response(k,:);
    clear spiketimes;
    clear psth;
end

for k=1:number_of_sound_stimuli
    
    number_of_repeats_in_recordings = size(data.set(k).repeats,2);
    time_length_of_sound = data.set(k).length_signal_ms;
    
    for i=1:number_of_repeats_in_recordings
        spiketimes = data.set(k).repeats(i).t;
        r_psth(i,:) = histc(spiketimes,t);
        if isempty(r_psth(i,:))
            r_psth(i,:) = zeros(size(r_psth(i,:),1),1);
        end
    end
    
    r{k,1} = r_psth;
    clear r_psth;
end

r_combo=r;

ex_data.combo=combo;
ex_data.r_combo=r_combo;
ex_data.t=t;
end
