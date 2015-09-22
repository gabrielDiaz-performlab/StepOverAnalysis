function [ETG_T,audio_Data,Fs] = loadEyeTracker(ETG_FilePath)

D = dir(ETG_FilePath);

for i = 1:length(D)
   if strfind(D(i).name, 'ExportData')
       
       D_1 = dir([ETG_FilePath '\' D(i).name]);
       
       if length(D_1)~=3
           display('This folder must contain only 1 text file')
       else
           ETG_T = readtable([ETG_FilePath '\ExportData\' D_1(end).name]);
       end    
       
   elseif isempty(strfind(D(i).name, 'ExportData')) && ~strcmp(D(i).name,'.') && ~strcmp(D(i).name,'..') && isdir(D(i).name)
       
        D_1 = dir([ETG_FilePath '\' D(i).name]);
        
        for j = 1:length(D_1)
            
            if ~isdir(D_1(j).name)
               [~,~,temp] = fileparts(D_1(j).name); 
               
               if strcmp(temp,'.wav')
                  [audio_Data,Fs] = audioread([ETG_FilePath '\' D(i).name '\' D_1(j).name]); 
               end
            end
            
        end
        
   end
       
       
end
end