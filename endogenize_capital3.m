function IO=endogenize_capital3(IO,meta,KbarCfc,n_CFC)
%%
    v=sum(IO.F(1:9,:),1);
    n_va=[3,4,5,7,8,9];
    d=IO.F(n_CFC,:)-sum(KbarCfc,1);   %Ideally, this should be zero. If not, the other components are adjusted to keep 
    IO.F(n_CFC,:)=sum(KbarCfc,1);     % value added constant
    adj=convertnan((sum(IO.F(n_va,:),1)+d)./sum(IO.F(n_va,:),1));
    IO.F(n_va,:)=IO.F(n_va,:)*diag(adj);
    v(2,:)=sum(IO.F(1:9,:),1);
    v(3,:)=v(1,:)./v(2,:);
    IO.xinv=ones(meta.Zdim,1)./IO.x;
    IO.xinv(IO.x==0)=0;
    %%
    IO.A=IO.A+KbarCfc*diag(IO.xinv);
    %%
    IO.Y(:,4:meta.NFDSECTORS:meta.Ydim)=IO.Y(:,4:meta.NFDSECTORS:meta.Ydim)-cnty_sum(KbarCfc,meta.NSECTORS,2); 
        %Replace gross with net capital formation
    IO.F(n_CFC,:)=0; IO.S(n_CFC,:)=0; IO.V(n_CFC,:)=0;  %set the consumption of fixed capital to zero
    IO.S(n_va,:)=IO.F(n_va,:)*diag(IO.xinv);
    %%
end