function [ex_data]=get_ex_data_mixmix_new(neuron_file,t)
% ------------------------------------------------------------------------%
% Author: Monzilur Rahman
%
% USAGE: [ex_data]=get_ex_data_mixmix(n,paths,t)
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
load(neuron_file);
number_of_sound_stimuli = size(data.set,2);
% ------------------------------------------------------------- %

% number of sitmuli
number_of_sound_stimuli = size(data.set,2);

% convert time to ms
t=t*1000;
    
for k=1:number_of_sound_stimuli
    % find stimulus id
    if isfield(data.set(k),'stim_params')
        if isfield(data.set(k).stim_params,'Mixture')
            Mixture = data.set(k).stim_params.Mixture;
            Sound_ID = data.set(k).stim_params.Sound_ID;
            StimID = Sound_ID + 16*(Mixture);
        else
            StimID = data.set(k).stim_params.StimID;
            if StimID<=16
                Mixture = 0;
                Sound_ID = StimID;
            else
                Mixture = 1;
                Sound_ID = StimID - 16;
            end
        end
    else
        if k<=16
            Mixture = 0;
        else 
            Mixture = 1;
        end
        Sound_ID = k;
        StimID = Sound_ID + 16*(Mixture);
    end
    
    % get spikes and repeats
    number_of_repeats_in_recordings = size(data.set(k).repeats,2);
    
    spiketimes = data.set(k).spikes.t;
    
    psth = histc(spiketimes,t);
    
    r(k,:) = psth/number_of_repeats_in_recordings; % spiking rates for 5ms bins
    
    ex_data.stim_params.Stim_ID(k) = StimID;
    ex_data.stim_params.Mixure(k) = Mixture;
    ex_data.stim_params.Sound_ID(k) = Sound_ID;
end

for k=1:number_of_sound_stimuli
    
    number_of_repeats_in_recordings = size(data.set(k).repeats,2);
    
    for i=1:number_of_repeats_in_recordings
        spiketimes = data.set(k).repeats(i).t;
        r_psth(i,:) = histc(spiketimes,t);
        spiketimes_repeats{k}{i}=spiketimes;
    end
    
    r_repeats{k,1} = r_psth;
    clear r_psth;
end

ex_data.r=r;
ex_data.r_repeats=r_repeats;
ex_data.spiketimes_repeats = spiketimes_repeats;
ex_data.t=t;
end
