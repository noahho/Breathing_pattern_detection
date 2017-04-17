function [d] = preprocess(d_, Config)
    SMOOTHING_METHODS = {'moving', 'lin'};
    SMOOTHING_METHOD = SMOOTHING_METHODS{Config('SMOOTHING_INDEX')};
    
    calibration_diff = (Config('CALIBRATION_MAX') - Config('CALIBRATION_MIN'));
    
    d_(:, 4) = medfilt1(d_(:, 4),3); % remove spiked    
    %acc{K}(:, 4) = wden(acc_k(:, 4),'heursure','s','one',4,'sym8');
    d_(:, 4) = smooth(d_(:, 4), SMOOTHING_METHOD);
    d_(:, 4) = d_(:, 4) - (Config('CALIBRATION_MIN') + calibration_diff/2);
    d_(:, 4) = d_(:, 4) / calibration_diff;
    d = d_;
end