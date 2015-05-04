

addpath(genpath('data'));
addpath(genpath('subFunctions'));
addpath(genpath('figureTools'));

textFileDir = 'data/raw/';
parsedTextFileDir = 'data/parsedTXT/';
sessionFileDir = 'data/sessionFiles/';
spssFileDir = 'data/spssFiles/';

[junk junk] = mkdir('figures');
[junk junk] = mkdir(spssFileDir );


dataFileList = {...
    'exp_data-2015-4-9-16-18'
    'exp_data-2015-4-10-15-31'
    'exp_data-2015-4-15-10-34'
    'exp_data-2015-4-14-16-15'
    'exp_data-2015-4-15-14-22'
    'exp_data-2015-4-16-14-16'
    'exp_data-2015-4-17-11-27'
    };

legLengthHardCoded_sIdx = [90 90 100];


%%
% hardExclusions(1).fileID = 'exp_data-2015-4-9-16-18';
% hardExclusions(1).id = [1 2];
% 
% hardExclusions(2).fileID = 'exp_data-2015-4-14-16-15';
% hardExclusions(2).id = [24 38 83];

%% Parameters used by algorithms

% Step detection findSteps.m
footHeightThresh = .13;
HSTOReorderThreshS = .2;

% Butterworth in findStepsMod.m
order = 7;
cutoff = 5;

%% Here where I hardcode variables that should be in the text file.

%legLength = .87;
%obsHeightRatio_trialType = [ .15 .25 .35 .15 .25 .35 ];

obsPositionIfWalkingUp = -3.5;
obsPositionIfWalkingDown = 2.4;

obsLW = [5,.03];

numConditions = 2;
numObsHeights = 3;

%obsHeightRatios = [.15 .25 .35];
footSize_LWH = [.25 .1 .07];

%standingBoxOffset_Z = - 2;

% Number of frames to search before and after the crossing for other features
crossingSearchWindowSize = 20; 

%% Figure colors / linestyles

lineStyle_cond = ['-',':'];
lineColor_cond = ['r','b'];
figBufferPro = .3;

outlierThreshold = 2;
