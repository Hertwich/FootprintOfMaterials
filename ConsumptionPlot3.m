%% Material CF of consumption and investment

% setcolors;
% set(groot,'defaultAxesColorOrder',colorcube(12));
ylab='Carbon Footprint (Gt CO_2e)';
[C.sec, C.name, ~]=xlsread('IPCCsec2.xlsx','MetSegAgg','G1:R201');
C.sec=convertnan(C.sec');
i=7:9;
c=1;
Mat1=C.sec*squeeze(sum(ind(i,c,:,end,:),1))*1e-12;
Mat2=C.sec*squeeze(ind(10,c,:,end,:)*1e-12);
Composition=[squeeze(Mat1(:,1)),squeeze(Mat1(:,21)),squeeze(Mat2(:,1)),squeeze(Mat2(:,21))];
%Composition=Composition;
L1=sum(Mat1(:,1:21),1);
L2=sum(Mat2(:,1:21),1);
%%
save 'FC_Products.mat' C year Mat1 Mat2 L1 L2 Composition 

%%
cl=parula(12);
legtext=C.name
figure
subplot(2,1,1)
%h=bar((Composition/diag(sum(Composition)))','stacked','FaceColor','flat');
h=bar(Composition','stacked');
for i=1:12
   h(i).FaceColor=cl(13-i,:);
end   
order=size(Mat1,1):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
%%
ylabel('Final demand (GtCO_2e)')
ax=gca;
ax.XTickLabel={'1995','2015','1995','2015'};
ax.XLim=[0.2 4.8];
ax.YLim=[0 7];
title('Consumption   Investment')
text(-0.8,7.4,'A','FontWeight','bold')
% text(0,7.5,'Consumption')
% text(2.5,7.5,'Net Investment')
axis square
text(5.15,7.4,'Products')
%%
% text(0.3,-1,'Consumption')
% text(2.6,-1,'Net Investment')
%hold on
%yyaxis right
%plot(1:1/20:2,L1','Color','k','LineWidth',2)
%plot(3:1/20:4,L2','Color','red','LineWidth',2)
%ax.YColor=[0,0,0];
%ax.YLim=[0,7];
%hold off
%%


xlswrite(filename, ...
    [[{'Consumption'};legtext'],num2cell([year;Mat1])],'Cons');
xlswrite(filename, ...
    [[{'Investment (net)'};legtext'],num2cell([year;Mat2])],'Cap');
%%
saveas(gca,[resultdest,'ConsInv.jpg']);
saveas(gca,[resultdest,'ConsInv.svg']);