clear
close all
clc
cd 'C:\Users\yyx18\Desktop\New folder';
% variable Name matching table 

% LP_1: HDL-3(chinese)==HDL-3(Sigma); LP_2: HDL-4(chinese)==HDL-3(Sigma)
[~, ~, LP] = xlsread('C:\Users\yyx18\Desktop\New folder\variable matching.xlsx','LP_2'); 
LP(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),LP)) = {''};
LP(1,:)=[];

% variable Name matching table
[~, ~, si_lp] = xlsread('C:\Users\yyx18\Desktop\New folder\LP_yyx.xlsx','LP');
si_lp(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),si_lp)) = {''};

[~, ~, ch_lp] = xlsread('C:\Users\yyx18\Desktop\New folder\20200417chinese_lab.xlsx','Sheet2');
ch_lp(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),ch_lp)) = {''};
ch_lp(1,:)=[]; ch_lp(522,:)=[];

%%
% 
a1=LP(:,1);
a2=LP(:,2);

[b1,c1]=ismember(a1,ch_lp(1,:));
[b2,c2]=ismember(a2,si_lp(2,:));

var_num=num2str(c2-2);

ch1=[];
ch1=ch_lp(3:end,c1);
sig=[];
sig=si_lp(4:end,c2);

% LP_1: HDL-3(chinese)==HDL-3(Sigma); LP_2: HDL-4(chinese)==HDL-3(Sigma)
cd 'C:\Users\yyx18\Desktop\New folder\comparision_LP_2'

for i=1:size(LP,1);
    cc=ch1(:,i);
    ss=sig(:,i);
    % remove empty sample
    index=cellfun(@isempty,ss,'uni',false);
    index=cellfun(@any,index);
    ss(index,:)=[];
    cc(index,:)=[];
    ss=cell2mat(ss);
    cc=cell2mat(cc);
    
    index2=find(cc==0);
    ss(index2,:)=[];
    cc(index2,:)=[];
        
    [r,p]=corr(cc,ss);
    r2=r.^2;
    r2=['R^2 = ' num2str(r2)];
    p=['p-val = ' num2str(p)];
    filename=cell2str(a2(i,1));
    % linear regression
    X = [ones(length(cc),1) cc];
    b = X\ss;
    yCalc2 = X*b;
    % plot
    figure,plot(cc,yCalc2,'--');hold on;
    scatter(cc,ss,'filled','MarkerFaceColor',[0 0.4470 0.7410]); grid on;
    % orange [0.8500 0.3250 0.0980]; yellow [0.9290 0.6940 0.1250]; blue [0 0.4470 0.7410]
    title([p '/ ' r2 '/ SampleSize: ' num2str(length(ss))]);
    xlabel('Chinese data');
    ylabel('SigMa data');
    print([var_num(i,:) filename '-scatterplot'], '-dpng','-r0');
    close all
end

