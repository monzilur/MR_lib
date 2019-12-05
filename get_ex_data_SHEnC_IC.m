function [ex_data,NR]=get_ex_data_SHEnC_IC(n,paths,bin_size)
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
location_of_sound_files = paths.location_of_sound_files;
neuronlist = paths.neuronlist;
data_folder = paths.data_folder;

neuron_file=strcat(data_folder,neuronlist{n});
load(neuron_file);

location_of_sound_files = paths.location_of_sound_files;
%number_of_sound_stimuli = size(data.set,2);
number_of_sound_stimuli = 20;
number_of_repeats_in_recordings = 20;
% calculate the number of repeats of each natural sound stimulus
for i=1:number_of_sound_stimuli
    l=i+10;
    repeat_number(i) = numel(data.set(l).repeats);
end

% if no stimulus has got less than a set number of repeats make run the
% subsequenct steps of data processing
if sum(repeat_number<20)==0
    % create stimuli
    scaling_constant=0;
    for i=1:number_of_sound_stimuli
        l=i+10;
        source = data.set(l).stim_params.Source;
        token = data.set(l).stim_params.Token;
        fw = data.set(l).stim_params.Set;
        frozen=data.set(l).stim_params.StimID;
        file_name = strcat(location_of_sound_files,'source.',...
            num2str(source),'.sound.0.snr.0.token.',num2str(token),...
            '.fw.',num2str(fw),'.frozen.',num2str(frozen));
        [x,fs] = audioread(file_name);
%         sound(x,fs);
%         disp(i);
%         pause(5.5);
        [stim{i,1},t]=cochleagram(x,fs,bin_size,'log');
        stimuli{i,1} = (stim{i,1}(:,:)-mean(stim{i,1}(:)))/std(stim{i,1}(:));
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
        l=k+10;
        %number_of_repeats_in_recordings = size(data.set(l).repeats,2);

        spiketimes = data.set(l).spikes.t;

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
        l=k+10;
        %number_of_repeats_in_recordings = size(data.set(l).repeats,2);
        time_length_of_sound = data.set(l).length_signal_ms;

        for i=1:number_of_repeats_in_recordings
            spiketimes = data.set(l).repeats(i).t;
            r_psth(i,:) = histc(spiketimes,t);
        end
        r{k,1} = r_psth;
        clear r_psth;
    end
    NR = calc_NR(cat(2,r{:}));
    ex_data.combo=combo;
    ex_data.r_combo=r;
    ex_data.t=t;
% otherwise, if any stimulus has got less than 20 repeats, ABORT!
else
    NR = 0;
    ex_data.combo=[];
    ex_data.r_combo=[];
    ex_data.t=[];
end
    
end
