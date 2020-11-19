% Used to display the results of the hypothetical extraction of materials
% in EXIOBASE. Changed in Nov. 2020 to change the display of materials.
%load 'MatTimeSeries191208.mat'
load 'GlobalMaterial.mat'
%%
period=1:21;
year=year(period);
resultdest='results 201103\';
filename=[resultdest,'FullTimeseries02-May-2019.xlsx'];
% clear C;
path(path,'.\funcs')
path(path,'..\matlabfuncs')
path(path,'..\GeneralMatlabUtilities')
%path(path,'..\..\MRIO\matlabfuncs')
%path(path,'..\..\MRIO\GeneralMatlabUtilities')
%xiopath='C:\Users\eh555\Dropbox (Yale_FES)\EX_v3_6_mat\';
xiopath='C:\Users\edgarhe\Dropbox (Yale_FES)\EX_v3_6_mat\';
load([xiopath, 'IOT_', num2str(year(1)), '_pxp.mat'],'meta');
[C.sec, ProdName, ~]=xlsread('IPCCsec2.xlsx','xio2detail','A2:H201');
C.sec=convertnan(C.sec');
[aa, AggMatName,~]=xlsread('IPCCsec2.xlsx','mat1','A2:Q11');
C.mat1=convertnan(aa(1:4,:));
C.mat2=convertnan(aa(5:10,:));
C.S23=convertnan(xlsread('IPCCsec2.xlsx','S23','B2:D201'));
[aa, name.mat3,~]=xlsread('IPCCsec2.xlsx','mat2','A2:Q9');
C.mat3=convertnan(aa);
[C.use, name.use,~]=xlsread('IPCCsec2.xlsx','MatUse','G1:M201');
C.use=convertnan(C.use);
for i=1:size(meta.labsZ,1)
    meta.labsZ(i,2)=regexprep(meta.labsZ(i,2),'\s\(\d*\)',''); %removes all terms in parenthesis in sector names
end
n_countries=meta.NCOUNTRIES;
n_sec=meta.NSECTORS;
n_GFCF=4:meta.NFDSECTORS:meta.Ydim;
n_CFC=6;
s=size(ind);
s2=size(gen);
%% Read Carbon budget numbers
GlobC=xlsread('Global_Carbon_Budget_2018v1.0.xlsx','Global Carbon Budget','A57:C78');
GlobCName={'year','fossil C','LUC'};
%% Cause of Material Emissions
%fix colors of area chart!
%sel_o=logical(ones(1,200));

% figure
% i=1; c=1;
% sel_o=true(1,200);
% sel_o(sel_sec)=0;
% setcolors();
% clear Mat2
% Mat2(1,:)=squeeze(sum(ind(i,c,sel_sec,end,:),3));
% Mat2(2:4,:)=C.S23(sel_o,:)'*squeeze(ind(i,c,sel_o,end,:));
% level=sum(Mat2);
% Mat2=Mat2/diag(sum(Mat2));
% labelx='year';
% labely='Source';
% legendx={'Material production','Energy supply','Mining','Other inputs'};
% subplot(3,2,1)
% h2=area(year,Mat2(:,1:end)','FaceColor','flat');
% ylabel(labely);
% yticklabels({'0%','50%','100%'})
% text(1989,1.15,'A','FontWeight','bold');
% yyaxis right
% plot(year,level*1e-12,'LineWidth',2,'Color','k')
% ylabel('GtCO_2e');
% order=size(h2,2):-1:1;
% u=legend(h2(order),legendx{order});
% u.Box='off';
% u.Location='eastoutside';
% ax=gca;
% ax.XLim=[year(1) year(end-1)];
% ax.XTick=[1995,2005,2015];
% ax.YLim=[0 12];
% ax.YTick=[0,6,12];
% axis square
% ax.YColor=[0,0,0];
figure
i=1; c=1;
sel_o=true(1,200);
sel_o(sel_sec)=0;
setcolors();
clear Mat2
Mat2(1,:)=squeeze(sum(ind(i,c,sel_sec,end,period),3));
Mat2(2:4,:)=C.S23(sel_o,:)'*squeeze(ind(i,c,sel_o,end,period));
level=sum(Mat2);
Mat2=Mat2/diag(sum(Mat2));
labelx='year';
labely='Source';
legendx={'Material production','Energy supply','Mining','Other inputs'};
subplot(3,2,1)
h2=area(year,Mat2(:,1:end)','FaceColor','flat');
ylabel(labely);
yticklabels({'0%','50%','100%'})
text(1989,1.15,'A','FontWeight','bold');
yyaxis right
plot(year,level*1e-12,'LineWidth',2,'Color','k')
ylabel('GtCO_2e');
order=size(h2,2):-1:1;
u=legend(h2(order),legendx{order});
u.Box='off';
u.Location='eastoutside';
ax=gca;
ax.XLim=[year(1) year(end-1)];
ax.XTick=[1995,2005,2015];
ax.YLim=[0 12];
ax.YTick=[0,6,12];
axis square
ax.YColor=[0,0,0];


%%
%xlswrite(filename, ...
%    [[{''},legendx]',num2cell([year;Mat2])],'Fig1A');

%% Material aggregated, area plot
i=1;
c=1;
Mat=squeeze(sum(ind(i,c,:,1:end-1,1:end),3)).*adj(:,1:end);
Mat2=C.mat3*Mat;
legtext=name.mat3;
%%
Mat2=Mat2/diag(sum(Mat2));
% figure
subplot(3,2,3)
h=area(year,Mat2','FaceColor','flat');  %
ylabel('Material')
yticklabels({'0%','50%','100%'})
text(1989,1.15,'B','FontWeight','bold');
yyaxis right
h2=plot(year,level*1e-12,'LineWidth',2,'Color','k');  %
ylabel('GtCO_2e');
h2.Color=[0,0,0];

order=size(h,2):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';

ax=gca;
ax.XLim=[year(1) year(end-1)];
ax.XTick=[1995,2005,2015];
ax.YLim=[0 12];
ax.YTick=[0,6,12];
axis square
ax.YColor=[0,0,0];
%%
%xlswrite(filename, ...
%    [[{'Materials'};legtext],num2cell([year;Mat2])],'Fig1B');
%% Material by using sector
ProdUse=C.use'*squeeze(ind(5,c,:,end,:));
ProdUse(end+1,:)=squeeze(sum(ind(6,c,:,end,:),3));
legtext=[name.use, {'Final Use'}];
%%
subplot(3,2,5)
% figure
ProdUse=ProdUse/diag(sum(ProdUse));
h=area(year,ProdUse','FaceColor','flat');
% title('Use of Materials')
% colormap winter; 
ylabel('Use')
yticklabels({'0%','50%','100%'})
text(1989,1.15,'C','FontWeight','bold');
yyaxis right
plot(year,level*1e-12,'LineWidth',2,'Color','k')
ylabel('GtCO_2e');
order=size(h,2):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
ax=gca;
ax.XLim=[year(1) year(end-1)];
ax.XTick=[1995,2005,2015];
ax.YLim=[0 12];
ax.YTick=[0,6,12];
axis square
ax.YColor=[0,0,0];
%%
xlswrite(filename, ...
    [[{'Using Industry'};legtext'],num2cell([year;ProdUse])],'Fig1C');
%% Display Material CF of final consumption by final consumer
i=7:12;
c=1;
Mat=squeeze(sum(ind(i,c,:,end,:),3))*1e-12;
legtext={'Households','NGOs','Government','Net Investment','Inventory adj','Valuables adj'};
figure
h=area(year,Mat','FaceColor','flat');
order=6:-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
title('Final Demand')
ylabel('Gt CO_2e')
ax=gca;
ax.XLim=[year(1) year(end-1)];
%%
% saveas(gca,[resultdest,'Consumption.jpg']);
% saveas(gca,[resultdest,'Consumption.svg']);
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat])],'FD');
%%
ConsumptionPlot

%% Display Materials over time
i=1;
c=1;
Mat=squeeze(sum(ind(i,c,:,:,:),3))*1e-12;
Mat(1:end-1,1:end)=Mat(1:end-1,1:end).*adj;
Mat(18,:)=sum(GlobC(:,2:3),2)'*3.664;
legendx=[ProdName(sel_sec);'All Materials';'Global CO_2'];
%%
figure
h=sorted_semilogy(1995:2015,Mat(:,1:end-1),legendx,'Eastoutside');
legend('boxoff')
ylabel('Energy use')
ylabel('Greenhouse gases (Gt CO_2e)');
yticklabels({'0.01','0.1','1','10','100'});
% saveas(gca,['GHGbyMaterial.jpg']);
%%
xlswrite(filename, ...
    [[{'Materials'};legendx],num2cell([year;Mat])],'Fig.S1');


%%
AA=ones(200,1);
AA(sel_sec)=0;


ProdUse=diag(AA)*squeeze(ind(5,c,:,end,:));
%         MFtot(i,:,:)=squeeze(sum(ind(1,c,:,:),3));
FinProdUse(:,:)=squeeze(sum(ind(6,c,:,end,:),3));

[PUsort, Isort]=sort(squeeze(ProdUse(:,17)),'descend');
PUs=[squeeze(ProdUse(Isort(1:10),:)); squeeze(sum(ProdUse(Isort(11:end),:),1)); FinProdUse'];
%%
legtext=[ProdName(Isort(1:10));'Other';'Final Use'];
figure
%subplot(3,1,3)
h=area(year,PUs'*1e-12);
order=12:-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
title('Sectors Using Materials')
ylabel('Use of Materials (Gt CO_2 equ)')
ax=gca;
ax.XLim=[year(1) year(end-1)];
%%
% saveas(gca,['All.jpg']);
xlswrite(filename, ...
    [[{''};legtext],num2cell([year;PUs])],'MatUse');

%%
% FU=squeeze(ind(6,c,1:6,end,:));
% legtext=meta.labsY(1:6,2);
% legtext={'Households','NGOs','Government','Net capital','Changes in inventories','Changes in valuables'};
% figure
% h=area(year,FU'*1e-12);
% order=6:-1:1;
% u=legend(h(order),legtext{order});
% u.Box='off';
% u.Location='eastoutside';
% ylabel('Use of Materials (Gt CO_2 equ)')
% ax=gca;
% ax.XLim=[year(1) year(end)];
% saveas(gca,['FinalUse.jpg']);
% %%
% xlswrite(filename, ...
%     [[{''},legtext]',num2cell([year;FU])],'FinUse');

%%
[C.ConsCat, legtext, ~]=xlsread('IPCCsec2.xlsx','ConsCat','C1:I201');
C.ConsCat=convertnan(C.ConsCat);
Mat=C.ConsCat'*squeeze(ind(3,1,:,end,:))*1e-12;
figure
h=area(year,Mat');
order=size(h,2):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
ylabel('Material carbon footprint (Gt CO_2 equ)')
ax=gca;
ax.XLim=[year(1) year(end-1)];
saveas(gca,['Consumption.jpg']);
%%
xlswrite(filename, ...
    [[{''},legtext]',num2cell([year;Mat])],'Cons');
%%
Mat=squeeze(ind(3,1,:,end,:))*1e-9;
[~, Isort]=sort(Mat(:,17),'descend');
xlswrite(filename,[[{''};ProdName(Isort)],num2cell([year;Mat(Isort,:)]),[{'Index'};num2cell(Isort)]],'Mdy');

