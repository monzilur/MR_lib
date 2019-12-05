function cellstr = num2cellstr(num_array)
% function num2cellstr(num_array)

    for i = 1:length(num_array)
        cellstr{1,i} = num2str(num_array(i));
    end
end