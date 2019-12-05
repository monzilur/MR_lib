function data=data_collect(destination_saved_file,single_units,name_tag)

% this function extractions the data about quality of models after training
file_names=dir(destination_saved_file);
load(strcat(destination_saved_file,'/run_ln_oct_2016',name_tag));
load(strcat(destination_saved_file,'/run_control_oct_2016',name_tag));
load(strcat(destination_saved_file,'/run_dn_oct_2016',name_tag));
load(strcat(destination_saved_file,'/run_control_mlp_oct_2016',name_tag));
load(strcat(destination_saved_file,'/run_dn_mlp_oct_2016',name_tag));

ind_single = find(single_units==1);

K_fold = 8;
j=1;
for i=ind_single;
    theta_cat{1,j}=model_ln(i).kernel;
    lam_optim_cat(1,j)=model_ln(i).net_str_optim{2}; 
    mean_optim_CCnorm=mean(model_ln(i).optim_CCnorm,1);
    optim_CCnorm_cat{1}(j,:)=mean_optim_CCnorm;
    optim_lam_cat{1,j}=model_ln(i).optim_lam;
    refit_CCnorm_cat(1,j)=model_ln(i).refit_quality{3};
    model_ln_cat(j)=model_ln(i).model_ln;
    CCnorm_cat(1,j)=max(mean_optim_CCnorm(isfinite(mean_optim_CCnorm)));
    if isfinite(max(mean_optim_CCnorm))==0
        for k=1:length(mean_optim_CCnorm)
            if isfinite(mean_optim_CCnorm(k))==0
                mean_optim_CCnorm(k)=0;
            end
        end
    end
    j=j+1;
end

j=1;
for i=ind_single;   
    theta_cat{2,j}=model_control(i).theta;
    net_str_optim_cat{2,j}=model_control(i).net_str_optim;
    lam_optim_cat(2,j)=model_control(i).net_str_optim{2};
    mean_optim_CCnorm=mean(model_control(i).optim_CCnorm,1);
    optim_lam_cat{2,j}=model_control(i).optim_lam;
    refit_CCnorm_cat(2,j)=model_control(i).refit_quality{3};
    refit_error_fun_cat{2,j}=model_control(i).refit_quality{6};
    
    CCnorm_cat(2,j)=max(mean_optim_CCnorm(isfinite(mean_optim_CCnorm)));
    
    if isfinite(max(mean_optim_CCnorm))==0
        for k=1:length(mean_optim_CCnorm)
            if isfinite(mean_optim_CCnorm(k))==0
                mean_optim_CCnorm(k)=0;
            end
        end
    end
    optim_CCnorm_cat{2}(j,:)=mean_optim_CCnorm;
    j=j+1;
end

j=1;
for i=ind_single;  
    theta_cat{3,j}=model_dn(i).theta;
    net_str_optim_cat{3,j}=model_dn(i).net_str_optim;
    lam_optim_cat(3,j)=model_dn(i).net_str_optim{2};
    mean_optim_CCnorm=mean(model_dn(i).optim_CCnorm,1);    
    optim_lam_cat{3,j}=model_dn(i).optim_lam;
    refit_CCnorm_cat(3,j)=model_dn(i).refit_quality{3};
    refit_error_fun_cat{3,j}=model_dn(i).refit_quality{6};
    
    CCnorm_cat(3,j)=max(mean_optim_CCnorm(isfinite(mean_optim_CCnorm)));
    
    if isfinite(max(mean_optim_CCnorm))==0
        for k=1:length(mean_optim_CCnorm)
            if isfinite(mean_optim_CCnorm(k))==0
                mean_optim_CCnorm(k)=0;
            end
        end
    end
    optim_CCnorm_cat{3}(j,:)=mean_optim_CCnorm;
    j=j+1;
end

j=1;
for i=ind_single;   
    theta_cat{4,j}=model_control_mlp(i).theta;
    net_str_optim_cat{4,j}=model_control_mlp(i).net_str_optim;
    lam_optim_cat(4,j)=model_control_mlp(i).net_str_optim{4};
    mean_optim_CCnorm=mean(model_control_mlp(i).optim_CCnorm,1);
    optim_CCnorm_cat{4}(j,:)=mean_optim_CCnorm;    
    optim_lam_cat{4,j}=model_control_mlp(i).optim_lam;
    refit_CCnorm_cat(4,j)=model_control_mlp(i).refit_quality{3};
    refit_error_fun_cat{4,j}=model_control_mlp(i).refit_quality{6};
    
    CCnorm_cat(4,j)=max(mean_optim_CCnorm(isfinite(mean_optim_CCnorm)));
    if isfinite(max(mean_optim_CCnorm))==0
        for k=1:length(mean_optim_CCnorm)
            if isfinite(mean_optim_CCnorm(k))==0
                mean_optim_CCnorm(k)=0;
            end
        end
    end
    optim_CCnorm_cat{4}(j,:)=mean_optim_CCnorm;    
    j=j+1;
end

j=1;optim_CCnorm_cat{5}(j,:)=mean_optim_CCnorm;
for i=ind_single; 
    theta_cat{5,j}=model_dn_mlp(i).theta;
    net_str_optim_cat{5,j}=model_dn_mlp(i).net_str_optim;
    lam_optim_cat(5,j)=model_dn_mlp(i).net_str_optim{4};
    mean_optim_CCnorm=mean(model_dn_mlp(i).optim_CCnorm,1);
    optim_CCnorm_cat{5}(j,:)=mean_optim_CCnorm;
    optim_lam_cat{5,j}=model_dn_mlp(i).optim_lam;
    refit_CCnorm_cat(5,j)=model_dn_mlp(i).refit_quality{3};
    refit_error_fun_cat{5,j}=model_dn_mlp(i).refit_quality{6};
    
    CCnorm_cat(5,j)=max(mean_optim_CCnorm(isfinite(mean_optim_CCnorm)));
    j=j+1;
end

% for i=ind_single;
%     noise_ratio(i)=NR(i);
% end

data.theta_cat=theta_cat;
data.lam_optim_cat=lam_optim_cat;
data.optim_CCnorm_cat=optim_CCnorm_cat;
data.net_str_optim_cat=net_str_optim_cat;
data.refit_CCnorm_cat=refit_CCnorm_cat;
data.CCnorm_cat=CCnorm_cat;
data.refit_error_fun_cat=refit_error_fun_cat;
data.model_ln_cat=model_ln_cat;
% data.noise_ratio=noise_ratio;

end
