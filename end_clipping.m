function [ ex_data_end_clipped ] = end_clipping( ex_data,exclusion_length,direction_clipping )
% [ ex_data_end_clipped ] = end_clipping( ex_data, exclusion_length, direction_clipping )
% END_CLIPPING: Function for discarding first few time bins of data
if nargin<3
    direction_clipping = 1;
end
    switch direction_clipping
        case 1
            for i=1:size(ex_data.combo,1);
                ex_data_end_clipped.combo{i,1}=ex_data.combo{i,1}(:,exclusion_length+1:end);
                ex_data_end_clipped.r_combo{i,1}=ex_data.r_combo{i,1}(:,exclusion_length+1:end);
            end
        case 2
            for i=1:size(ex_data.combo,1);
                ex_data_end_clipped.combo{i,1}=ex_data.combo{i,1}(:,1:end-exclusion_length);
                ex_data_end_clipped.r_combo{i,1}=ex_data.r_combo{i,1}(:,1:end-exclusion_length);
            end
    end

end

