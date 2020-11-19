%% Material CF of consumption and investment

% setcolors;
%set(groot,'defaultAxesColorOrder',parula(size(C.c,1)));
ylab='Carbon footprint (Gt CO_2e)';
% 
legtext=C.name;
i=7:9;
c=1;
Mat1c=C.c*squeeze(sum(ind(i,c,:,end,:),1))*1e-12;
Mat2c=C.c*squeeze(ind(10,c,:,end,:)*1e-12);
Mat3c=C.c*squeeze(sum(ind(11:12,c,:,end,:),1))*1e-12;
CompositionC=[squeeze(Mat1c(:,1)),squeeze(Mat1c(:,21)),squeeze(Mat2c(:,1)),squeeze(Mat2c(:,21))];
%Composition=Composition;
L1c=sum(Mat1c(:,1:21),1);
L2c=sum(Mat2c(:,1:21),1);
%%
save 'FC_Countries.mat' C year Mat1c Mat2c L1c L2c
%%
cl=parula(size(C.c,1));
%figure
subplot(2,1,2)
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
ylabel('Final demand (GtCO_2e)')
ax=gca;
%ax.YColor=[0,0,0];
ax.YLim=[0.2,4.8];
ax.YLim=[0 7];
ax.XTickLabel={'1995','2015','1995','2015'};
text(-0.8,7.4,'B','FontWeight','bold')
axis square
text(5.15,7.4,'Regions')
%%
xlswrite(filename,{'Consumption (including consumption of fixed capital)'},'Fig2B');
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat1c])],'Fig2B','A2');
xlswrite(filename,{'Consumption (including consumption of fixed capital)'},'Fig2B','A16');
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat2c])],'Fig2B','A17');
xlswrite(filename,{'Change in inventories, Change in valuables'},'Fig2B','A31');
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat3c])],'Fig2B','A32');
xlswrite(filename,{'Total'},'Fig2B','A46');
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;(Mat1c+Mat2c+Mat3c)])],'Fig2B','A47');
%%
% hold on
% plot(1:1/20:2,L1','Color','k','LineWidth',2)
% plot(3:1/20:4,L2','Color','red','LineWidth',2)

%hold off
%%

figure
subplot(1,3,1)
h=stairs(year,Mat1c');
ylabel(ylab)
title('a. Consumption')
ax=gca;
ax.XLim=[year(1) year(end)];
ylim=ax.YLim;
ax.YLim=ylim;
% xlswrite(filename, ...
%     [[{''};legtext'],num2cell([year;Mat])],'Cons2');
%%
subplot(1,3,2)
Mat=C.c*squeeze(ind(10,c,:,end,:)*1e-12);
h=area(year,Mat');
title('b. Investment')
ax=gca;
ax.XLim=[year(1) year(end)];
ax.YLim=ylim;
order=size(Mat,1):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat])],'Cap2');
%%
saveas(gca,[resultdest,'ConsInv2.jpg']);
saveas(gca,[resultdest,'ConsInv2.svg']);

%%
ylab='GHG Emissions (Gt CO_2e)';
% 
legtext=C.name;
i=1;
c=1;
Mat=C.c*squeeze(sum(ind(i,c,:,end,:),1))*1e-12;
figure
subplot(1,4,1)
h=area(year,Mat');
ylabel(ylab)
title('a. Origin')
ax=gca;
ax.XLim=[year(1) year(end)];
ylim=ax.YLim;
ax.YLim=ylim;
%%
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat])],'ProdT');
%%
subplot(1,4,2)
i=3;
Mat=C.c*squeeze(ind(i,c,:,end,:)*1e-12);
h=area(year,Mat');
title('b. Destination')
ax=gca;
ax.XLim=[year(1) year(end)];
ax.YLim=ylim;
order=size(Mat,1):-1:1;
u=legend(h(order),legtext{order});
u.Box='off';
u.Location='eastoutside';
%%
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat])],'ConInv2');

%%
subplot(1,4,3)
i=3;
Mat=C.c*(squeeze(ind(1,c,:,end,:)*1e-12)-squeeze(ind(3,c,:,end,:)*1e-12));
h=line(year,Mat','LineWidth',2.5);
title('c. Net Trade')
ax=gca;
ax.XLim=[year(1) year(end)];
% order=size(Mat,1):-1:1;
% u=legend(h(order),legtext{order});
% u.Box='off';
% u.Location='eastoutside';
%%
xlswrite(filename, ...
    [[{''};legtext'],num2cell([year;Mat])],'Trade');
%%
saveas(gca,[resultdest,'PvC.jpg']);
saveas(gca,[resultdest,'PvC.svg']);
