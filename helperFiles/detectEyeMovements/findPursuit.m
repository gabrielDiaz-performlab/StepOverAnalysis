display('* Identifying periods of tracking...')

% g2BallDegs_fr

pursAllFr_idx_onOff = zeros(1,numel(eiwFiltDegsX_fr));
pursExclusionCode_fr  = zeros(1,numel(eiwFiltDegsX_fr));

% 0:  Gaze is not within purs_degThresh of the ball's edge

% Start off by marking all possible pursuit frames with a 1
% gaze must be within purs_degThresh of the ball's edge
% ... and above vel thresh (not a fixation)

%pursExclusionCode_fr( intersect( find( g2BallDegs_fr <= purs_degThresh), find(gazeVelDegsSec_fr > vel_thresh))) = 1;
pursExclusionCode_fr( find( g2BallDegs_fr <= purs_degThresh) ) = 1;

% intersect( find( g2BallDegs_fr < purs_degThresh),find(gazeVelDegsSec_fr > vel_thresh))

%%
% 2: Pursuit gain criterion!
pursExclusionCode_fr(  find(  pursuitGain_fr < purs_e2bChangeThresh_Low))  = 2;
pursExclusionCode_fr(  find(  pursuitGain_fr > purs_e2bChangeThresh_High)) = 2;

% 3: Pursuit cannot occur during a fixation
for i = 1:size(fixAllFr_idx_onOff,1)
    pursExclusionCode_fr(fixAllFr_idx_onOff(i,1):fixAllFr_idx_onOff(i,2)) = 3;
end

%%% Clump pursuits within clump_t_thresh of one another
lastPur = find( pursExclusionCode_fr== 1,1,'first');

for idx = (lastPur+1):numel(pursExclusionCode_fr)

    if( pursExclusionCode_fr(idx) == 1) 
                
        if( (eyeDataTime_fr(idx) - eyeDataTime_fr(lastPur)) <= (purs_clump_t_thresh/1000) )
            pursExclusionCode_fr(lastPur:idx) = 1;
        end
        
        lastPur = idx;
        
    end
    
end


%%
%%%  Convert pursExclusionCode_fr into start/stop frames of pursuits of
%%%  length > purs_durThresh

pursAllFr_idx_onOff = zeros(numel(pursExclusionCode_fr),1);
pursAllFr_idx_onOff( pursExclusionCode_fr  ~= 1 ) = 0;
pursAllFr_idx_onOff( pursExclusionCode_fr == 1 ) = 1;


%%  Find those above duration threshold
%aboveDurThresIdx = find( 1000*(sceneTime_fr(pursAllFr_idx_onOff(:,2))-sceneTime_fr(pursAllFr_idx_onOff(:,1))) > purs_durThresh );
%tempExcCodeVec = setdiff( 1:size(pursAllFr_idx_onOff,1), aboveDurThresIdx);

if( unique(pursAllFr_idx_onOff) ~= 0)
    
    %%% Pursuit must last for purs_durThresh.
    pursAllFr_idx_onOff = contiguous(pursAllFr_idx_onOff,1); % This converts pursAllFr_idx_onOff into the format pursAllFr_idx_onOff(:,1) = start frames, and (:,2) = stop frames
    pursAllFr_idx_onOff = pursAllFr_idx_onOff{2};

    pursBelowDurThresIdx = find( 1000*(eyeDataTime_fr(pursAllFr_idx_onOff(:,2)) - eyeDataTime_fr(pursAllFr_idx_onOff(:,1))) < purs_durThresh );

    for xx= 1:numel(pursBelowDurThresIdx )
        pursExclusionCode_fr( pursAllFr_idx_onOff(pursBelowDurThresIdx(xx),1):pursAllFr_idx_onOff(pursBelowDurThresIdx(xx),2)) = 4;
    end

    pursAllFr_idx_onOff(pursBelowDurThresIdx,:)=[];

    clear tempExcCodeVec
end
%% Organize data for eyedatabrowser

%  I've turned this off for now.
%clear pursAllID_idx_onOff
%pursAllID_idx_onOff(:,1) = movieID_fr( pursAllFr_idx_onOff(:,1) );
%pursAllID_idx_onOff(:,2) = movieID_fr( pursAllFr_idx_onOff(:,2) );



%%
% %% Some lines of code I use for debugging
% 
% % x is the ID of the frame that I want to investigate
% x = 46464
% 
% fprintf([ '\n' mat2str(pursExclusionCode_fr( (id2idx(x)-10):(id2idx(x)-1))) ' *' mat2str( pursExclusionCode_fr(id2idx(x))) '* ' mat2str(pursExclusionCode_fr( (id2idx(x)+1):(id2idx(x)+10))) '\n'])
% 
% aa =pursAllID_idx_onOff( find( pursAllID_idx_onOff(:,1) <= x,1,'last'),:);
% 
% if( x >= aa(1) && x <= aa(2) )
%     display('Found within a pursuit defined by pursAllID_idx_onOff')
% else
%     display('Not a within a pursuit defined by pursAllID_idx_onOff')
% end
% 
% xx= find(movieID_fr == x);
% bb =pursAllFr_idx_onOff( find( pursAllFr_idx_onOff(:,1) <= xx,1,'last'),:);
% 
% if( xx >= bb(1) && xx <= bb(2) )
%     display('Found within a pursuit defined by pursAllFr_idx_onOff')
% else
%     display('Not a within a pursuit defined by pursAllFr_idx_onOff')
% end
