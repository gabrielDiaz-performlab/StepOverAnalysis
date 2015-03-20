
%dataFileFolder = '\MatlabDataFiles\';
addpath(genpath('rawData'));
addpath(genpath('sessionFiles'));
addpath(genpath('structFiles'));
addpath(genpath('subFunctions'));
addpath(genpath('figureTools'));

textFileDir = 'rawData/';
sessionFileDir = 'sessionFiles/';
structFileDir = 'structFiles/';

[junk junk] = mkdir('OutputFigures');


dataFileList = {...
    'exp_data-2015-3-16-17-18',...
    'exp_data-2015-3-16-17-22',...
    };

%% Parameters used by algorithms

% Step detection findStepsMod.m
footHeightThresh = .1;

% Butterworth in findStepsMod.m
order = 7;
cutoff = 5;

%% Here where I hardcode variables that should be in the text file.

legLength = .87;
obsHeightRatio_trialType = [ .15 .25 .35 .15 .25 .35 ];

obsPositionIfWalkingUp = -3.5;
obsPositionIfWalkingDown = 2.4;

obsLW = [5,.03];



%standingBoxOffset_Z = - 2;
