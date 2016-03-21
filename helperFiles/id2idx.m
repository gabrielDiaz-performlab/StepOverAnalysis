function idx =  id2idx(ID);

global dataFileString;

processedDataFileString = [dataFileString '-processed.mat'];

impData = load( processedDataFileString,'movieID_fr');

idx = find(ID(1) == impData.movieID_fr):find(ID(end) == impData.movieID_fr);

