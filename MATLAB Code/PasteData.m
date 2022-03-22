function RetData = PasteData(DataSet, DataName, Data)
%Searches for 'DataName' in 'DataSet' and pastes 'Data' below it

[row, col] = find(strcmp(DataSet,DataName));
DataSet( row+1:(row+length(Data)),col ) = Data;

RetData = DataSet;
end