function ec_score=ec_score_sigmoid(zhat)
% function ec_score=ec_score_sigmoid(zhat)
    ec_score=2*(mean(zhat(:))-1);
end