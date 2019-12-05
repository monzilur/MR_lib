function [ ex_data_end_clipped ] = end_clipping_mixmix( ex_data,exclusion_length, bin_size)
% [ ex_data_end_clipped ] = end_clipping( ex_data, exclusion_length, direction_clipping, bin_size)
% END_CLIPPING: Function for discarding first few time bins of data
    for i=1:size(ex_data.r,1)
        ex_data_end_clipped.r(i,:)=ex_data.r(i,exclusion_length+1:end);
        ex_data_end_clipped.r_repeats{i,1}=ex_data.r_repeats{i,1}(:,exclusion_length+1:end);
        for j=1:size(ex_data.spiketimes_repeats{i},1)
            ex_data_end_clipped.spiketimes_repeats{i}{j}=...
                ex_data.spiketimes_repeats{i}{j}(...
                ex_data.spiketimes_repeats{i}{j}>exclusion_length*bin_size);
        end
    end

end

