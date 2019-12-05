function ie_score=ie_score_calc(W_unit,sign_unit)
% ic_score=ic_score_calc(W_unit,sign_unit)
    ie_score = sign_unit*sum(W_unit(:))/sum(abs(W_unit(:)));
end