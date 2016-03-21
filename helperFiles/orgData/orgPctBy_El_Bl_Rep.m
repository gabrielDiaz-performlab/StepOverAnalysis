
function [pctData_el_bl] = orgPctByEl_Bl_Rep(dataFileString,dataIn_fr)

%loadParameters
try
    impData =  load( [dataFileString '-processed.mat'],'trInBlk_Cblk','numBlocks','elasticityList','elasticity_tr');
catch
    impData =  load( ['Data/Extracted/' dataFileString '-processed.mat'],'trInBlk_Cblk','numBlocks','elasticityList','elasticity_tr');
end

numBlocks = impData.numBlocks;
trInBlk_Cblk = impData.trInBlk_Cblk;
elasticityList = impData.elasticityList;
elasticity_tr = impData.elasticity_tr;

for bIdx = 1:numBlocks
    for eIdx = 1:numel(elasticityList)
        
        idx = intersect(  trInBlk_Cblk{bIdx},find(elasticity_tr==elasticityList(eIdx)));
        
        pctData_el_bl(eIdx,bIdx) = 100 * (sum(dataIn_fr(idx)) ./ numel(idx));
        
    end
end
