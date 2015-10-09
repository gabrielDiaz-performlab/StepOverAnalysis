
function [avgHandPlanarVelFilt_el_bl stdHandPlanarVelFilt_el_bl dataOut_Cel_bl_rep] = orgByEl_Bl_Rep(dataFileString,dataIn_fr,remOutliersBeyondZ)

try
    impData =  load( [dataFileString '-processed.mat'],'trInBlk_Cblk','numBlocks','elasticityList','elasticity_tr');
catch
    impData =  load( ['Data/Extracted/' dataFileString '-processed.mat'],'trInBlk_Cblk','numBlocks','elasticityList','elasticity_tr');
end

%%
%%impData = load( [dataFileString '-processed.mat'],'trInBlk_Cblk','numBlocks','elasticityList','elasticity_tr');

numBlocks = impData.numBlocks;
trInBlk_Cblk = impData.trInBlk_Cblk;
elasticityList = impData.elasticityList;
elasticity_tr = impData.elasticity_tr;

if( remOutliersBeyondZ > 0)
    dataIn_fr = removeOutliers(dataIn_fr,remOutliersBeyondZ,inputname(1));
end

for bIdx = 1:numBlocks
    for eIdx = 1:numel(elasticityList)
        
        
        idx = intersect(  trInBlk_Cblk{bIdx},find(elasticity_tr==elasticityList(eIdx)));
        
        dataOut_Cel_bl_rep{eIdx,bIdx} = dataIn_fr(idx);
        avgHandPlanarVelFilt_el_bl(eIdx,bIdx) = nanmean(dataIn_fr(idx));
        stdHandPlanarVelFilt_el_bl(eIdx,bIdx) = nanstd(dataIn_fr(idx));
        
    end
end
