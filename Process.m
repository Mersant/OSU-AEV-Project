function [NewData, ProcessedData] = Process(Data,OldDataName,NewDataName,Operation,Y)
%Finds data under a certain header, processes, then pastes under a new
%location.
%   Example: Data = Process(Data,'Watts','KiloWatts','X./1000');
%   ^ This would find all data located under 'Watts,' divide it by 1000,
%   then paste the output below wherever 'KiloWatts' is in the file.

[rowIn, colIn] = find(strcmp(Data,OldDataName));% Original data coordinates
[rowOut, colOut] = find(strcmp(Data,NewDataName));% New data coordinates
X = cell2mat(Data(rowIn+1:end,colIn)); % 'row' is incremented by 1 so that
% new information is pasted below the text and does not overwrite said text
if nargin > 4
    [dataRow,dataCol] = find(strcmp(Data,Y));
    Y = cell2mat(Data(dataRow+1:end,dataCol)); 
end
X = eval(Operation); % Process X data using whatever was specified in 'Operation'
ProcessedData = X;
X = num2cell(X); % Convert back into cell format for pasting into 'Data'
Data(rowOut+1:(length(X)+rowOut),colOut) = X;
NewData = Data;
end