
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
    'exp_data-2015-4-1-19-9'...
    'exp_data-2015-4-2-15-32'
    };

%% Parameters used by algorithms

% Step detection findSteps.m
footHeightThresh = .1;
HSTOReorderThreshS = .2;

% Butterworth in findStepsMod.m
order = 7;
cutoff = 5;

%% Here where I hardcode variables that should be in the text file.

legLength = .87;
obsHeightRatio_trialType = [ .15 .25 .35 .15 .25 .35 ];

obsPositionIfWalkingUp = -3.5;
obsPositionIfWalkingDown = 2.4;

obsLW = [5,.03];

numConditions = 2;
numObsHeights = 3;

obsHeightRatios = [.15 .25 .35];
footSize_LWH = [.25 .1 .07];

%standingBoxOffset_Z = - 2;

%% Figure colors / linestyles

lineStyle_cond = ['-',':'];
lineColor_cond = ['r','b'];
figBufferPro = .3;

outlierThreshold = 2;