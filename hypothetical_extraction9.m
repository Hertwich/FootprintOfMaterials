function indi=hypothetical_extraction9(sel_sec,IO,n_sec,n_countries,S,GFCF)
%%
% adjusted from version 5 to include final demand type (households,
% government, investments, etc.
% adjusted from version 6 to a hypothetical extraction approach

        IOE.A=IO.A;
        IOE.Y=IO.Y;
        GFCFE=GFCF;
        nY=size(IO.Y,2)/size(IO.pop,1);  %number of final demand cateogries
        for i=1:n_countries              %set all extracted sectors to zero
            IOE.A((i-1)*n_sec+sel_sec,:)=0;
            IOE.Y((i-1)*n_sec+sel_sec,:)=0;
            GFCFE((i-1)*n_sec+sel_sec,:)=0;
        end
        
%         MM=S/(eye(size(IOE.A))-IOE.A);
%         xx=(eye(size(IOE.A))-IOE.A)\sum(IOE.Y,2);
        IOE.L=inv(eye(size(IOE.A))-IOE.A);
        IOE.M=S*IOE.L;
        
        %%
        IOE.x=IOE.L*sum(IOE.Y,2);
        % calculate production based global total HEM impact
        indi(1,:,:)=sec_sum(S*diag(IO.x-IOE.x),n_sec,2);

        % calculate change in global total HEM impact
        indi(2,:,:)=sec_sum((IO.M-IOE.M)*diag(IO.x),n_sec,2);
        %indi(2,:)=sec_sum((IO.M*diag(IO.x)-IOE.M*diag(IOE.x)),n_sec,2);
        % calculate change in global final HEM impact
        %indi(3,:)=sec_sum((IO.M-IOE.M)*diag(sum(IO.Y,2)),n_sec,2);
        indi(3,:,:)=sec_sum((IO.M*diag(sum(IO.Y,2))-IOE.M*diag(sum(IOE.Y,2))),n_sec,2);
        indi(4,:,:)=sec_sum((IO.M*diag(sum(GFCF,2))-IOE.M*diag(sum(GFCFE,2))),n_sec,2);    
%         indi(5,:,:)=sec_sum(IO.M*diag((IO.A-IOE.A)*IOE.L*sum(IOE.Y,2)),n_sec,2);
        
        % Mj * Zj (row) - Flow of embodied factor to sectors
        % Mj * Yj (row) - Flow of embodied factors to final demand
        
        %indi(5,:,:)=0;
        indi(6,:,:)=0;
        M=IO.M-IOE.M;
        indi(5,:,:)=sec_sum(IO.M*(IO.A-IOE.A)*diag(IOE.x),n_sec,2);
        %%
%         for i=1:size(sel_sec,2)
%             %indi(5,:,:)=squeeze(indi(5,:,:))+sec_sum(M(:,sel_sec(i):n_sec:end)*IO.Z_ZK(sel_sec(i):n_sec:end,:),n_sec,2);
%             indi(6,:,1:nY)=squeeze(indi(6,:,1:nY))+sec_sum(IO.M(:,sel_sec(i):n_sec:end)*IO.Y(sel_sec(i):n_sec:end,:),nY,2);
%         end    
        %indi 5+6 is more than total. should not be. maybe capital
        %internalization is a problem if FD is not corrected correctly.
        %check. 
        Y=sec_sum(IO.Y,nY,2);
        YE=sec_sum(IOE.Y,nY,2);
        %%
        indi(6,:,1)=IO.M*sum(Y-YE,2);
        %%
        for i=1:nY-1
            indi(6+i,:,:)=sec_sum(IO.M*diag(Y(:,i))-IOE.M*diag(YE(:,i)),n_sec,2);
        end
        
        M=sec_sum(IO.M*diag(sum(IO.Y,2)),n_sec,2)./(sec_sum(sum(IO.Y,2),n_sec,1)'+0.1);
        Mh=sec_sum(IOE.M*diag(sum(IOE.Y,2)),n_sec,2)./(sec_sum(sum(IOE.Y,2),n_sec,1)'+0.1);  
        %%
        % change in multipliers as a fraction of original multiplier
        indi(13,:,:)=(M-Mh)./(M+0.001);
end