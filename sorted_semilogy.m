function h=sorted_semilogy(X,Y,legtxt,leglocation)
[~, yi]=sort(Y(:,1));
order=size(Y,1):-1:1;
%%
lines={'-','--',':','-.','--',':','-','-.','-','--'}';
lines=[lines;lines];
mrk={'o','+','*','d','x','s','.','^','v','h','p','>'}';
mrk=[mrk;mrk];
% figure
h=semilogy(X,Y(yi,:));
xlim([X(1),X(end)]);

set(h,{'LineStyle'},lines(1:size(h,1)));
set(h,{'Marker'},mrk(1:size(h,1)));
set(h,'MarkerSize',4);
u=legend(h(order),legtxt{yi(order)});
u.Location=leglocation;
end
%% 
