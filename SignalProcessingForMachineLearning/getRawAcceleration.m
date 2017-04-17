function [acc] = getRawAcceleration(varargin) %#ok<STOUT>
% getRawAcceleration helps retrive acceleration data from relevant file
% Input arguments need to be Name,Value pairs. Acceptable names are
% - SubjectID: Subject ID, rangnig from 1 to 30
% - AccelerationType: Acceleration type, as a choice between 'total' and
% 'body' (with gravity contributions filtered out)
% - Component: Coordinate name, as a choice between 'x', 'y', or 'z'
% 
% Copyright 2014-2015 The MathWorks, Inc.


% Create: subjects, fs, actlabels
load('dataset.mat')

p = inputParser;

defaultSubject = 1;

defaultComponent = 'x';
validComponents = {'x','y','z', 'stretch'};
checkComponent = @(x) any(validatestring(x,validComponents));

defaultState = 1;
maxState = 9;

addParameter (p,'SubjectID',defaultSubject,@(x) x > 0 && x <= subjects);
addParameter (p,'Component',defaultComponent,checkComponent);
addParameter (p,'State',defaultState,@(x) x > 0 && x <= maxState);

parse(p,varargin{:})

subid = p.Results.SubjectID;
switch p.Results.Component
    case 'x', component = 1;
    case 'y', component = 2;
    case 'z', component = 3;
    case 'stretch', component = 4;
end
state = p.Results.State;

acc = data{subid, state};