function stimuli=stretched_stimuli(neuron_file,p,q,args)
% ======================================================================= %
% Author: Monzilur Rahman
%
% USAGE: stretched_stimuli(sound_file,p,q,F)
%
% A function that stretches/ resamples the stimuli file p/q times in length
%
% INPUTS:
% neuron_file: the file that contains the name of files containing the
% sound clips
% p,q: numbers determining the extent of stretching
% F: Number of frequency channels to be created in the cochleagram
%
% OUTPUT:
% stimuli: an array containing the cochleagram of re-scaled stimuli
%
% ======================================================================= %

% Defaults
    
if exist('args.F')==0
    F=34;
else
    F=args.F;
end

if exist('args.freq_range')==0
    iFreq = 0.5;
    fFreq = 22.627;
else
    iFreq = args.freq_range(1);
    fFreq = args.freq_range(2);
end

if exist('args.bin_size')==0
    bin_size=5;
else
    bin_size=args.bin_size;
end

f=logspace(log10(iFreq),log10(fFreq),F);

% load data
load(neuron_file);
number_of_sound_stimuli = size(data.set,2);

% create stimuli
location_of_sound_files = '../sound_data/cochleagram/';

scaling_constant=0;

for i=1:number_of_sound_stimuli;
    source = data.set(i).stim_params.Source;
    token = data.set(i).stim_params.Token;
    fw = data.set(i).stim_params.Set;
    frozen=data.set(i).stim_params.StimID;
    file_name = strcat(location_of_sound_files,'source.',num2str(source),'.sound.0.snr.0.token.',num2str(token),'.fw.',num2str(fw),'.frozen.',num2str(frozen));
    [x,fs] = audioread(file_name);
%         sound(x,fs);
%         disp(i);
%         pause(5.5);
    [coch{i,1},t]=cochleagram(x,fs,5,'log');
    coch_re{i,1} = resample(coch{i,1}',p,q);
    stim{i,1} = coch_re{i,1}';
    stimuli{i,1} = (stim{i,1}(:,:)-mean(stim{i,1}(:)))/std(stim{i,1}(:));
end

    
end

