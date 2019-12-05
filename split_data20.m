function [crossvalid_data_set,test_data]=split_data20(ex_data,rand_num)
% ======================================================================= %
% Author: Monzilur Rahman
% 
% USAGE: [output1 output2] = split_data(ex_data,rand_num)
%
% function that splits the data into a test and cross-validation set
% also splits the validation set into K-fold training and validation set
% 
% INPUT:
% ex_data: a structure containg stimuli and neural responses in cell arrays
% In the first element of the structure, the last row of the cell arrays are
% neural responses expressed as PSTH and the rows before contains the 
% cochleagram of the stimuli. The second element of the structure contains
% only the neural responses in different repeated trails of same stimuli
% rand_num: a random sequence of numbers 1 to 16. This usually saved in the
% working directory
%
% OUTPUT:
% crossvalid_data:
% Similar to ex_data the crossvalid data contains various cells that have
% the whole crossvalidation set and the splited K-fold training and
% validation set.
% test_data:
% contains test dataset
% test_data.test=test;
% test_data.r_test=r_test;
% crossvalid_stimuli=[1:3,5:6,8:9,11:19];
% test_stimuli=[4,7,10,20];
% ======================================================================= %

crossvalid_stimuli=[1:3,5:6,8:9,11:19];
test_stimuli=[4,7,10,20];

combo=ex_data.combo;
r_combo=ex_data.r_combo;

for i=1:length(crossvalid_stimuli);
crossvalid{i,1}=combo{crossvalid_stimuli(i),1};
r_crossvalid{i,1}=r_combo{crossvalid_stimuli(i),1};
end

for i=1:length(test_stimuli);
test{i,1}=combo{test_stimuli(i),1};
r_test{i,1}=r_combo{test_stimuli(i),1};
end

num=1:16;

j=1;
for i=1:2:15;
    rand_com=[rand_num(i),rand_num(i+1),find(num~=rand_num(i)&num~=rand_num(i+1))];
    valid=crossvalid(rand_com(1:2));
    r_valid=r_crossvalid(rand_com(1:2));
    
    training=crossvalid(rand_com(3:16));
    r_training=r_crossvalid(rand_com(3:16));
    
    training_data_set{j}={training,r_training};
    valid_data_set{j}={valid,r_valid};
    j=j+1;
end

crossvalid_data_set.crossvalid_data={crossvalid, r_crossvalid};
crossvalid_data_set.training_data_set=training_data_set;
crossvalid_data_set.valid_data_set=valid_data_set;

test_data.test=test;
test_data.r_test=r_test;
end