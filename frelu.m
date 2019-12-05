function y=frelu(x)

for i=1:size(x,1)
    for j=1:size(x,2)
        if x(i,j)>0
            y(i,j) = x(i,j);
        else
            y(i,j) = 0;
        end
    end
end
end