function p = calculateChangepoints(d, display, Config)
    CHANGE_POINT_METHODS = {{'linear', 0.02}, {'mean', 0.035}, {'mean', 0.05}, {'mean', 0.06}};
    
    change_point_method = CHANGE_POINT_METHODS{Config('CHANGE_POINT_METHOD')};

    if (display == 1)
        findchangepts(d,'Statistic',change_point_method{1},'MinThreshold',change_point_method{2},'MinDistance',Config('CHANGE_POINT_MINDIST'));
    end
    [p, ~] = findchangepts(d,'Statistic',change_point_method{1},'MinThreshold',change_point_method{2},'MinDistance',Config('CHANGE_POINT_MINDIST'));
end