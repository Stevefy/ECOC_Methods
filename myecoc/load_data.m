%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function focus on loading data 
% input parameters are file path and dataname 
% note that the data should formated as 'traindata.mat','trainlabel.mat','testdata','testlabel'
% note that all labels are numbers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [td,dl,testdata,data_test_label] = load_data(path,dataname)
    % % %load data         
    td=[];dl=[];testdata=[];data_test_label=[];
    dtype={'traindata','trainlabel','testdata','testlabel'};     
    for j=1:size(dtype,2)
        matname=[path,dataname,'_',dtype{j},'.mat'];
        load(matname);         
    end
    if(isempty(td)==true || isempty(dl)==true || isempty(testdata)==true || isempty(data_test_label)==true)
        error('Exit:load data error!');
    end
end