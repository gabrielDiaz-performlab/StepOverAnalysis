addpath(genpath('data'));
addpath(genpath('subFunctions'));
addpath(genpath('figureTools'));
addpath(genpath('AudioFunctions'))
addpath(genpath('geom3d'))
addpath(genpath('C:\Users\Rakshit\Documents\MATLAB\Cluster_Fix'))

textFileDir = 'data/raw/';
parsedTextFileDir = 'data/parsedTXT/';
sessionFileDir = 'data/sessionFiles/';
spssFileDir = 'data/spssFiles/';
videoDir = 'D:\Walking analysis videos';

[~, ~] = mkdir('figures');
[~, ~] = mkdir(parsedTextFileDir);
[~, ~] = mkdir(sessionFileDir );
[~, ~] = mkdir(spssFileDir );

clear junk

%Ensure that the walking data and ETG data are added appropriately

dataFileList = {...
    %'_data-2015-10-8-18-52'...
    %'_data-2016-2-5-18-34'...
    %'_data-2016-2-23-18-58' %1
    %'_data-2016-3-1-16-11' %2
    %'_data-2016-3-3-16-51'
    %'_data-2016-3-9-15-37' %3
    %'_data-2016-4-21-15-57'
    %'_data-2016-4-22-14-55' %4
    %'_data-2016-4-25-16-12' %5
    %'_data-2016-4-28-18-5' %6
    %'_data-2016-5-3-14-29' %7
    '_data-2016-5-5-14-37' %8
    
    };

ETG_dataFileList = {...
    %'Sanketh_FinalData 08-10-2015 18 48 30'...
    %'sanketh0205'...
    %'Sanketh 23-02-2016 18 56 41' %1
    %'Anna 01-03-2016 16 06 33' %2
    %'Brendan 03-03-2016 16 24 17'
    %'Swati 09-03-2016 14 56 35' %3
    %'Gabe_Pilot 21-04-2016 15 52 27'
    %'Participant_2 22-04-2016 14 47 14' %4 
    %'Participant_4 25-04-2016 15 58 43' %5
    %'Participant_5 28-04-2016 17 49 09' %6
    %'Participant_6 03-05-2016 14 12 05' %7
    'Participant_7 05-05-2016 14 31 32' %8
    };

ETG_videoFileList = {...
    %'Sanketh 23-02-2016 18 56 41' %1
    %'Anna 01-03-2016 16 06 33' %2
    %'Gabe_Pilot 21-04-2016 15 52 27'
    %'Participant_2 22-04-2016 14 47 14' %4
    %'Participant_4 25-04-2016 15 58 43' %5
    %'Participant_5 28-04-2016 17 49 09' %6
    %'Participant_6 03-05-2016 14 12 05' %7
    %'Participant_7 05-05-2016 14 31 32' %8
    };
    
DeleteTrials = {...
    %[]
    %[]
    %[]
    %[]
    %[]
    %[]
    %[] 
    []
    %[2,3,4,5,6]
    %[]
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

% Distance of subject from Start Box after Obstacle becomes visible
showObsAtDistOf = 1;
%% Here where I hardcode variables that should be in the text file.

%legLength = .87;
%obsHeightRatio_trialType = [ .15 .25 .35 .15 .25 .35 ];

% obsPositionIfWalkingUp = -3.5;
% obsPositionIfWalkingDown = 2.4;

obsLW = [1.24,.087];

numConditions = 1;
numObsHeights = 3;

footSize_LWH = [.25 .1 .07];

%% Audio information

fAudio = 5000; 
beep_Dur = 0.125;

%% Eye to Obstacle Angular separation threshold
tAngSep = 20;

roiTemporalClumpThreshMS = 50;
roiOnObsMinDuration = 50;

%% Figure colors / linestyles

lineStyle_cond = ['-',':'];
lineColor_cond = ['r','b'];
figBufferPro = .3;

outlierThreshold = 2;
