function lam_matrix=lambdas(lam_initial,lam_div)
n_lam = 9;
lam = lam_initial;

lam_matrix = lam;

ii = 2;
for i = 1:n_lam
    if and(i>=2,i<=5)
        for j= 1:3
             lam = lam/(lam_div^(1/3));
             lam_matrix(ii)=lam;
             ii=ii+1;
        end
    else
        lam = lam/lam_div;
        lam_matrix(ii)=lam;
        ii=ii+1;
    end
end
end