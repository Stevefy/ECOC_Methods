%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function is to get adjusted classes
% parameters are group1, group2, traindata, trainlabel and DC measure option 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [adjusted_c1,adjusted_c2] = get_swap_group(c1,c2,train,label,DC_OPTION)
    [subclass_c1,sbuclass_c2] = select_adjusted_class(c1,c2,train,label,DC_OPTION);
    [adjusted_c1,adjusted_c2]=swap_class(c1,c2,subclass_c1,sbuclass_c2);   
end

function [adjusted_c1,adjusted_c2] = select_adjusted_class(c1,c2,train,label,DC_OPTION)
    funstr = ['get_complexity',DC_OPTION];
    fh = str2func(funstr);
    
    %����m-1�Եĸ��Ӷ�ֵ
    group = [c1',c2'];
    res = zeros([max(group) max(group)]);
    for i = 1:size(group,2)
        for j=i+1:size(group,2)
           res(group(i),group(j)) = fh(group(i),group(j),train,label);
           res(group(j),group(i)) = res(group(i),group(j));
        end
    end
    
    %����ÿ����ĸ��ӶȺ͵ľ�ֵ
    ressum = zeros(1,max(group));
    res = res/(size(group,2)-1);
    for i = 1:size(res,2)
       ressum(i) = sum(res(i,:)); 
    end
    
    %��ѡ���Ӷ�����������
    ressum1 = ressum(c1);
    ressum2 = ressum(c2);
    adjusted_c1 = c1(find( ressum1 == max(ressum1)));
    adjusted_c2 = c2(find( ressum2 == max(ressum2)));
    
    
    %������Ӷ���������ڶ����ֻѡ���һ��
    if(size(adjusted_c1,2) ~= 1 || size(adjusted_c1,1) ~=1)
        adjusted_c1 = adjusted_c1(1);
    end
    
    if(size(adjusted_c2,2) ~= 1 || size(adjusted_c2,1) ~=1)
        adjusted_c2 = adjusted_c2(2);
    end   

end

function [c1,c2] = swap_class(c1,c2,swap_1,swap_2)
    index1 = find(c1 == swap_1);
    index2 = find(c2 == swap_2);
    c1(index1) = swap_2;
    c2(index2) = swap_1;   
end