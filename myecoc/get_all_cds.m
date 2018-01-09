%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function generate all DC ECOC coding matrices 
% input parameters are class number, traindata, trainlabel,dc option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tcds,tcplx] = get_all_cds(total_cls_num,td,dl,option)
options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};
if(strcmp('ALL',option)==1)
    for o=1:size(options,1)
        [cds,cplx]=get_cds(td,dl,total_cls_num,o);
        tcplx{o}=cplx;
        tcds{o}=cds;
    end
else
    for o=1:size(options,1)
        if(strcmp(option,options{o})==1)
            [cds,cplx]=get_cds(td,dl,total_cls_num,o);
            tcplx{1}=cplx;
            tcds{1}=cds;
            break;
        end
    end
end

end
function [cds,cplx]=get_cds(td,dl,total_cls_num,o)
options={'F1';'F2';'F3';'N2';'N3';'N4';'L3';'Cluster'};

% % % coding matrix
class = (1:total_cls_num)';
cds=zeros([total_cls_num,total_cls_num]);
global gcount;
gcount=0;

[cds,cplx] = coding(class,td,dl,cds,{},total_cls_num,options{o});


% % ȥ�������0��
temp = [];
for i =1:size(cds,2)
    if(any(cds(:,i)~=0))
        temp = [temp,cds(:,i)];
    end
end
cds = temp;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ���ɵ���codematrix�͸��Ӷ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cds,fcplx]=coding(class,traindata,trainlabel,cds,fcplx,total_cls_num,option) 
    global gcount;
    % % %���㸴�Ӷȣ����ֳ�����
    s=floor(size(class)/2);
    t=size(class);
    c1=class(1:s,:);
    c2=class(s+1:t,:);
    if(size(c1,1)==0 | size(c2,1)==0)
        error('Exit:group c contains no subclass!');    
    else
        %%%m-1�Ը��Ӷ�ƥ����ѡ���Ӷ��������ཻ��
        [c11,c12,tcplx] = get_complexity(c1,c2,traindata,trainlabel,option);
    end   
    
    % % %����code matrix
    code=zeros([total_cls_num,1]);
    code(c11)=1;
    code(c12)=-1;
    gcount=gcount+1;
    cds(:,gcount)=code;
    fcplx{gcount}=tcplx;
  
    if(size(c11,1)>=2)       
        [cds,fcplx]=coding(c11,traindata,trainlabel,cds,fcplx,total_cls_num,option);   
    end

    if(size(c12,1)>=2)        
        [cds,fcplx]=coding(c12,traindata,trainlabel,cds,fcplx,total_cls_num,option); 
    end
end     

%�õ����еĸ��Ӷ�
function [c1,c2,tcplx]=get_complexity(c1,c2,train,label,DC_OPTION)
    disp(['now computing the ',DC_OPTION]);
    funstr = ['get_complexity',DC_OPTION];
    fh = str2func(funstr);
    cplx = fh(c1,c2,train,label);
    tcplx = cplx;
    while(true)
        pre_c1=c1;
        pre_c2=c2;

        [adjusted_c1,adjusted_c2] = get_swap_group(c1,c2,train,label,DC_OPTION);
        new_cplx = fh(adjusted_c1,adjusted_c2,train,label);
        
        flag = 0;%0��ʾ�����н��� 1��ʾ���н���
        if(is_contains(DC_OPTION) == true)
            if(new_cplx > cplx)
               flag = 1;
            end
        else
            if(new_cplx < cplx)
               flag = 1;
            end
        end
        if(flag==1)
            c1=adjusted_c1;
            c2=adjusted_c2;
            cplx=new_cplx;
            tcplx=[tcplx cplx];
        else
            c1=pre_c1;
            c2=pre_c2;
            break;
        end
    end
end

function res = is_contains(str)
    strings = {'F1','F3'};
    res = false;
    for i = 1:size(strings,2)
        if(strcmp(strings{i},str) == 1)
            res = true;
            break;
        end
    end
end
        