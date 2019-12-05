function [selectivity] = calc_selectivity(CC1,CC2,threshold)
%[selectivity] = calc_selectivity(CC1,CC2,threshold)
    if ~exist('threshold')
        threshold = 0.1;
    end
    
    CC1(isnan(CC1)) = 0;
    CC2(isnan(CC2)) = 0;
    %
    selectivity=(abs(CC1)-abs(CC2))./(abs(CC1) + abs(CC2));
    %
    selectivity(and(CC1 >= 0,CC2 < 0)) = 1;
    selectivity(and(CC2 >= 0,CC1 < 0)) = -1;
    %
    selectivity(sqrt(CC1.^2 + CC2.^2) <=threshold) = 0;
    selectivity(or(and(CC1 <= threshold,CC2 <= 0),and(CC2 <= threshold,CC1 <= 0))) = 0;
end