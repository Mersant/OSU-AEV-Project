%function RetData = CopyData(Data, DataName)
%Searches for "DataName" in "Data" and returns all data below it
%   Ex. Data = CopyData(MyData, 'Age');
[row, col] = find(strcmp(Data,DataName));
RetData = Data(row-1:end, col);
%end