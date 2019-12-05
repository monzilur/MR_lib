function [CCnorm,MSE,lam_optim,refit_CCnorm] = get_data(ind_single,model_data,varargin)
% [CCnorm,MSE,lam_optim,refit_CCnorm] = get_data(ind_single,model_data,varargin)
% varargin specifies where to use mean or median to calculated the average
% on K-fold crossvalidation

if nargin > 2 
    average = varargin{1};
else
    average = 'mean';
end
    j=1;
    for i=ind_single   
        % theta{j}=model_data(i).theta;
        net_str_optim{j}=model_data(i).net_str_optim;
        lam_optim(j)=model_data(i).net_str_optim{4};
        switch average
            case 'mean'
                mean_optim_CCnorm=mean(model_data(i).optim_CCnorm,1);
            case 'median'
                mean_optim_CCnorm=median(model_data(i).optim_CCnorm,1);
        end
        optim_CCnorm(j,:)=mean_optim_CCnorm;
        refit_CCnorm(j)=model_data(i).refit_quality{3};

        if isfinite(max(mean_optim_CCnorm))==0
            for k=1:length(mean_optim_CCnorm)
                if isfinite(mean_optim_CCnorm(k))==0
                    mean_optim_CCnorm(k)=0;
                end
            end
        end
        optim_CCnorm(j,:)=mean_optim_CCnorm;
        
        [CCnorm(j),I]=max(mean_optim_CCnorm);
        
        if isfield(model_data, 'training_quality')
            quality = model_data(i).training_quality;
        else
            quality = model_data(i).train_quality;
        end
        
        for k=1:size(quality,1)
            optim_MSE(j,k)=quality{k,I}{2};
            % there is difference between optim_CCnorm and optim_MSE
            % one with 18 colums and the later with 8 columns
            MSE(j)=mean(optim_MSE(j,:));
        end
        j=j+1;
    end
end