function [ex_data]=get_split_data(n)
load stimuli;
load noise_ratios;
% get the neural response for 1 neuron
neuron_file=neuronlist{n};

load(neuron_file);

% calculate psth
combo=cell(20,1);
F = 34; % number of frequencies
t=0:5:4990;
for k=1:20;
    spiketimes = data.set(k).spikes.t;
    psth = histc(spiketimes,t);
    response(k,:) = psth/20; % spiking rates for 5ms bins

    combo{k,1} = zeros(F+1,size(response,2));
    
    % stimuli and neural responses combined in a cell array
    combo{k,1}(1:F,1:size(stimuli{1,1},2))=stimuli{k,1};
    combo{k,1}(F+1,:)=response(k,:);
    clear spiketimes;
    clear psth;
end

t=0:5:4990;
for k=1:20;
    for i=1:20;
        spiketimes = data.set(k).repeats(i).t;
        psth(i,:) = histc(spiketimes,t);
    end
    r{k,1} = psth(:,:)/20;
    clear psth;
end
    
% split data into test and training
L=length(combo{1});

for i=1:20;
training{i,1}=combo{i}(:,1:L-300);
crossvalid{i,1}=combo{i}(:,L-299:L-200);
test{i,1}=combo{i}(:,L-199:end);

r_training{i,1}=r{i}(:,1:L-300);
r_crossvalid{i,1}=r{i}(:,L-299:L-200);
r_test{i,1}=r{i}(:,L-199:end);
end
ex_data={combo,training,crossvalid,test,r_training,r_crossvalid,r_test};
end

%save('combo2','combo','training','crossvalid','test','r_training','r_crossvalid','r_test');
% for i=1:20;
%  X{i} = tensorize(combo{i}(1:34,:), 20);
%  y{i} = combo{i}(35,:);
% end

% Z=cat(3,X{:});
% P=cat(2,y{:});
% k = sepkerneltensor2(Z,P);
% imagesc(k.k_f*k.k_h')
% pause(0.2)