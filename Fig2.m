% Fig. 2 in Carbon footprint of materials paper
% Carbon footprint divided in consumption and net investment


load FC_Products.mat
[C.sec, C.name, ~]=xlsread('IPCCsec2.xlsx','MetSegAgg','G1:R201');
%%
Composition=[squeeze(Mat1(:,1)),squeeze(Mat1(:,21)),squeeze(Mat2(:,1)),squeeze(Mat2(:,21))];
legtext=C.name;
cl=parula(12);
figure
subplot(2,2,1)
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
ax.YLim=[0 7.2];
title('Consumption   Investment')
text(-0.8,7.7,'A','FontWeight','bold')
% text(0,7.5,'Consumption')
% text(2.5,7.5,'Net Investment')
axis square
text(5.15,7.7,'Products')
sum(Composition,1)
%%
clear
load FC_Countries.mat
cl=parula(size(C.c,1));
legtext=C.name;
CompositionC=[squeeze(Mat1c(:,1)),squeeze(Mat1c(:,21)),squeeze(Mat2c(:,1)),squeeze(Mat2c(:,21))];
subplot(2,2,3)
%h=bar((Composition/diag(sum(Composition)))','stacked','FaceColor','flat');
h=bar(CompositionC','stacked');
for i=1:size(C.c,1)
   %h(i).FaceColor=cl(size(C.c,1)-i+1,:);
   h(i).FaceColor=cl(i,:);
end   
order=size(Mat1c,1):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
ylabel('Carbon footprint (GtCO_2e)')
ax=gca;
ax.XTickLabel={'1995','2015','1995','2015'};%ax.YColor=[0,0,0];
ax.YLim=[0.2,4.8];
ax.YLim=[0 7.2];
title('Consumption   Investment')
text(-0.8,7.7,'B','FontWeight','bold')
axis square
text(5.15,7.7,'Regions')
sum(CompositionC,1)