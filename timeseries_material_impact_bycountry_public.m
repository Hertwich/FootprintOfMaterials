%%

clear all;
clc;
close all; 
%%
path(path,'.\funcs')
path(path,'..\matlabfuncs')
path(path,'..\GeneralMatlabUtilities')
path(path,'..\..\MRIO\Concordances')
%xiopath='C:\Users\eh555\Dropbox (Yale_FES)\EX_v3_6_mat\';
xiopath='C:\Users\edgarhe\Dropbox (Yale_FES)\EX_v3_6_mat\';
%year=1995:2015;
% year=[1995,2015];
year=2011;
sel_sec=[104 108 112 106 110 114 101 40 41 103 97 58 60 62 96 86];
%sel_c=[1;111;119;124;131; 187; 109]; %
sel_c=[187; 109; 1]; 
names_C={'GHG emissions','Energy use','Value Added'};
%names_C={'Value added','Domestic Extraction','Water','Land','CO2 emissions','GHG emissions','Energy use'};
%[C1, ProdName, ~]=xlsread('IPCCsec2.xlsx','xio2detail','A2:H201');
[C1, ProdName, ~]=xlsread('EXIOBASE30r_CC10r.xlsx','7r','B1:H50');
C1=convertnan(C1');
load([xiopath, 'IOT_', num2str(year(1)), '_pxp.mat'],'meta');
for i=1:size(meta.labsZ,1)
    meta.labsZ(i,2)=regexprep(meta.labsZ(i,2),'\s\(\d*\)',''); %removes all terms in parenthesis in sector names
end
n_countries=meta.NCOUNTRIES;
n_sec=meta.NSECTORS;
n_GFCF=4:meta.NFDSECTORS:meta.Ydim;
n_CFC=6;

for i=1:size(sel_c,1)
  disp(['Selected indicator:' meta.labsC(sel_c(i))]);
end
%%
s=[13,size(sel_c,1)+size(sel_sec,2),meta.NCOUNTRIES,size(sel_sec,2)+1,size(year,2)];
ind=zeros(s);
gen=zeros(meta.NFDSECTORS+1,s(2),s(3),s(5));
indi_flat=zeros(s(3),s(1)*s(4)*size(sel_c,1)); % Turn data structure into a 2D matrix, n_sector * other dimensions ordered
heading = cell(4,s(1)*s(4)*size(sel_c,1)*s(5));     % Represent the dimensions of the 2D matrix
indi_sector = zeros(4,s(1)*s(4)*size(sel_c,1),s(5));  % Add additional, sector specific information
indi_sec = zeros(s(1)*s(4)*size(sel_c,1),s(5));
xsum=zeros(s(3),s(5));                              %sum of total output per global sector and year
adj=zeros(s(4)-1,s(5));                               %adjustment of material production volume to avoid double counting
%%
name.indi_dim1={'E^h_j','delta(M)*x','delta(M*y)','delta(M)*GFCF','M_j*Z_jk','M_j*Y_jk', ...
    'd HH','d NGO','d Gov','d NCF','d invent','d val','deltaM/M'};
% indi_dim3_name=ProdName;
% indi_dim4_name=ProdName(sel_sec);
name.indi_dim3=meta.countrynames;
name.indi_dim4=meta.labsZ(sel_sec,2);
name.indi_dim4(size(sel_sec,2)+1)={'All extracted products'};
name.indi_dim2(1:size(sel_c,1))=meta.labsC(sel_c,1);
name.indi_dim2(size(sel_c,1)+(1:size(sel_sec,2)))=meta.labsZ(sel_sec,2);
name.indi_dim5=year;
name.gen_dim1={'HH','NGO','Gov','NCF','invent','val','F','hhld_emis'};
%%
for a=1:s(5)
    %%
    disp(['Loading data for year ',num2str(year(a))]);
    load([xiopath, 'IOT_', num2str(year(a)), '_pxp.mat'], 'IO');
    load([xiopath,'Capital\Kbar_exio_v3_6_',num2str(year(a)),'pxp.mat']);
    %%
    GFCF=IO.Y(:,n_GFCF);
    IO=endogenize_capital3(IO,meta,KbarCfc,n_CFC);
    %IO=endogenize_capital(IO,meta);
    %%
    S=zeros(size(sel_c,1)+size(sel_sec,2),meta.Zdim); 
    S(1:size(sel_c,1),:)=IO.char(sel_c,:)*IO.S;
    for i=1:size(sel_sec,2)
        %disp(['Extracted sector:' meta.labsZ(sel_sec(i),2)]);
        S(i+size(sel_c,1),sel_sec(i)+n_sec*((1:n_countries)-1))=1; 
    end
    IO.M=S/(eye(meta.Zdim)-IO.A);   
    xsum(:,a)=cnty_sum(IO.x,n_sec,1);
    %%
       for i=1:size(sel_sec,2)                         
        ind(:,:,:,i,a)=hypothetical_extraction8(sel_sec(i),IO,n_sec,n_countries,S,GFCF);
        disp(['Extracted sector ',char(meta.labsZ(sel_sec(i),2)),'  ',num2str(year(a))]);
       end
    %%
    
    ind(:,:,:,i+1,a)=hypothetical_extraction8(sel_sec,IO,n_sec,n_countries,S,GFCF);
    %%
    disp('Extracted all investigated sectors.');
    gen(:,:,:,a)=footprint_cnty(IO,S,sel_c,n_sec);
    
        %% Adjustment factor for double counting
    % Zm is the production volume of each material in each extraction
    % scenario. If the individual extraction scenarios are multiplied by
    % the adj vector, the total amount of materials is produced. 
    Zm=squeeze(sum(squeeze(ind(1,size(sel_c,1)+1:end,:,:,a)),2));
    adj(:,a)=Zm(:,1:end-1)\Zm(:,end);
%     Zmadj=Zm(:,1:end-1)*diag(adj);
%     Bm=diag(Zm(:,end))\Zmadj;
    if (Zm(:,end)-sum(Zm(:,1:end-1)*diag(adj(:,a)),2))>200
        disp('adjustment is not achieved');
    end

    %% 
    %%
end
  
%%

ind=ind(:,:,:,:,1);s(5)=1;
indi_sec=zeros(4,s(1)*s(4)*size(sel_c,1)*s(5));
heading=cell(4,s(1)*s(4)*size(sel_c,1)*s(5));
for i=1:size(sel_c,1)%s(2)
    for j=1:s(1)
        for k=1:s(4)
            r=(i-1)*s(1)*s(4)*s(5)+(j-1)*s(4)*s(5)+(k-1)*s(5)+(1:s(5));
            indi_flat(:,r)=squeeze(ind(j,i,:,k,:));
            heading(1,r)=name.indi_dim2(i);
            heading(2,r)=name.indi_dim1(j);
            heading(3,r)=name.indi_dim4(k);
            heading(4,r)=num2cell(year);
    %         dall(r)=d(j);
        end
       
%         r=(i-1)*s(1)*s(4)+(j-1)*s(4)+(1:s(4));
%         for a=1:s(5)
%             indi_sec(1,(i-1)*s(1)*s(4)*s(5)+(j-1)*s(4)*s(5)+(a)+s(5)*(0:s(4)-2))=diag(squeeze(ind(j,i,sel_sec,1:s(4)-1,a)));
%             indi_sec(1,(i-1)*s(1)*s(4)*s(5)+(j-1)*s(4)*s(5)+(a)+s(5)*(s(4)-1))=sum(squeeze(ind(j,i,sel_sec,s(4),a))); 
%         end
    end
   disp(i)
end


%%
save('MatTimeSeriesbycountry.mat', 'ind','indi_flat','gen','heading','names_C','sel_sec','xsum','adj','year','name');
%%
filename=['CountryImpact1',date,'.xlsx'];
% load('global impact v0605.mat');

% %%
indi_compact=C1*indi_flat;  
indi_sum=sum(indi_flat,1);
%%
for i=1:s(4)
    x(:,(i-1)*s(5)+(1:s(5)))=xsum(:,1:s(5));
end
for i=1:size(sel_c,1) %s(2)
    r=(i-1)*s(1)*s(4)*s(5)+(s(1)-1)*s(4)*s(5)+(1:s(4)*s(5));
    indi_compact(:,r)=(C1*(x.*indi_flat(:,r)))./(C1*x);
    indi_sum(:,r)=sum((x.*indi_flat(:,r)),1)./sum(x,1);
end
%%
xls=[num2cell(1:s(3))',name.indi_dim3,num2cell(indi_flat)];
xls=[cell(4,2),heading;xls];
xlswrite(filename,xls,'Detail');
clear xls
%%
xls=[heading;num2cell([indi_compact;indi_sum])];
xls=[[cell(4,1);ProdName';'Sum'],xls];%
%{'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU+','Sum','Extracted Sector','Sector','GCFC','NCFC'}'],xls];
xlswrite(filename,xls,'Summary2');

%%
heading2=cell(4,size(sel_c,1)*s(1)*s(5));
indiM=zeros(s(3),size(sel_c,1)*s(1)*s(5));
for i=1:s(4)
    for j=1:size(sel_c,1)
        for k=1:s(1)
                r=(j-1)*s(1)*s(5)+(k-1)*s(1)+(1:s(5));
                indiM(:,r)=squeeze(ind(k,j,:,i,:));
                heading2(1,r)=name.indi_dim2(j);
                heading2(2,r)=name.indi_dim1(k);
                heading2(3,r)=name.indi_dim4(i);
                heading2(4,r)=num2cell(year);
        end
    end
    %xls=[cell(size(heading2,1),2),heading2;num2cell(1:200)',indi_dim3_name,num2cell(indiM)];
    xls=[heading2;num2cell(indiM)];
    xls=[xls; cell(2,size(xls,2))];
    xls=[xls; heading2(2:3,:);num2cell([C1*indiM;sum(indiM,1)])];
    collab=[cell(3,1);name.indi_dim3;cell(3,1);...
        ProdName';'Sum';cell(4,1)];
%         {'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU+','Sum','Extracted sector','Sector','GFCF resp. Y','NFCF'}'];
    if k<s(4)
        %sheet=sprintf('%10s',meta.secLabsZ.CodeTxt{sel_sec(k)});
        sheet=regexprep(meta.secLabsZ.CodeTxt{sel_sec(k)},'C_','');
    else
        sheet='ALL';
    end
    xlswrite(filename,xls,sheet)
end

%%
for i=1:s(4)
    %%
    for j=1:size(sel_c,1)
        for k=1:s(1)
            r1=(j-1)*s(1)*s(4)*s(5)+(k-1)*s(4)*s(5)+(i-1)*s(5)+(1:s(5));
            r2=(j-1)*s(1)*s(5)+(k-1)*s(5)+(1:s(5));
            heading2(:,r2)=heading(:,r1);
            indiM(:,r2)=indi_flat(:,r1);
            %indi_sec2(:,r2)=indi_sec(:,r1);
        end       
    end
    %%
    xls=[heading2;num2cell(indiM);cell(2,size(indiM,2))];
    %%
    xls=[xls;heading2([2,4],:);num2cell(C1*indiM);num2cell(sum(indiM,1))];
    %%
   % xls=[xls;num2cell(indi_sec2)];
    %%
    collab=[cell(4,1);name.indi_dim3;cell(4,1);...
        ProdName';'Sum'];
        %{'Energy','Transport','Materials','Industry','Services','Buildings','AFOLU+','Sum','Extracted sector','Sector', ...
        %'GFCF resp. Y','NFCF'}'];
    %%
    if i<s(4)
            sheet=regexprep(meta.secLabsZ.CodeTxt{sel_sec(i)},'C_','');
    else
            sheet='ALL';
    end
    xlswrite(filename,[collab,xls],sheet)
    %%
end

%%
h=sorted_semilogy(year,squeeze(sum(ind(1,1,:,:,:),3))*1e-12,[ProdName(sel_sec);'All Materials'],'Eastoutside');
h.ylabel='Pg CO_2 equ.';
%%
% %%

disp('Fin')
disp(' ')

