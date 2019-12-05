function y = fprimerelu(x)

for i=1:size(x,1)
    for j=1:size(x,2)
        if x(i,j)>0
            y(i,j) = 1;
        else
            y(i,j) =0;
        end
    end
end
    
end