addpath(genpath('data'));
addpath(genpath('subFunctions'));
addpath(genpath('figureTools'));

textFileDir = 'data/raw/';
parsedTextFileDir = 'data/parsedTXT/';
sessionFileDir = 'data/sessionFiles/';
spssFileDir = 'data/spssFiles/';

[junk, junk] = mkdir('figures');
[junk, junk] = mkdir(parsedTextFileDir);
[junk, junk] = mkdir(sessionFileDir );
[junk, junk] = mkdir(spssFileDir );

clear junk

%Ensure that the walking data and ETG data are added appropriately

dataFileList = {...
    '_data-2015-10-1-17-26'...
    };

ETG_dataFileList = {...
    'AudioCheck 01-10-2015 17 20 32'...
    };

% Step detection findSteps.m
% footHeightThresh_sIdx = [.13,]; We will likely need a diff. threshold for
% different subjects. 

footHeightThresh = 0.13;
  
%%
% hardExclusions(1).fileID = 'exp_data-2015-4-9-16-18';
% hardExclusions(1).id = [1 2];
% 
% hardExclusions(2).fileID = 'exp_data-2015-4-14-16-15';
% hardExclusions(2).id = [24 38 83];

%% Parameters used by algorithms

% heel-striek toe-off re-order threshold
HSTOReorderThreshS = .2;

% Butterworth in findStepsMod.m
order = 7;
cutoff = 5;

% Number of frames to search before and after the crossing for other features
crossingSearchWindowSize = 20; 


%% Here where I hardcode variables that should be in the text file.

%legLength = .87;
%obsHeightRatio_trialType = [ .15 .25 .35 .15 .25 .35 ];

% obsPositionIfWalkingUp = -3.5;
% obsPositionIfWalkingDown = 2.4;

obsLW = [1.24,.087];

numConditions = 2;
numObsHeights = 3;

footSize_LWH = [.25 .1 .07];

%% Audio information

fAudio = 2093; 
beep_Dur = 0.25;

%% Figure colors / linestyles

lineStyle_cond = ['-',':'];
lineColor_cond = ['r','b'];
figBufferPro = .3;

outlierThreshold = 2;
