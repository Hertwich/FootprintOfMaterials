function output=sec_sum(input,sec,dim)
if floor(size(input,dim)/sec)==size(input,dim)/sec
    if dim==1
        output=zeros(sec,size(input,2));
        for i=1:sec
            output(i,:)=sum(input(i:sec:end,:),dim);
        end
    elseif dim==2
        output=zeros(size(input,1),sec);
        for i=1:sec
            output(:,i)=sum(input(:,i:sec:end),dim);
        end
    else
        disp('error!!');
    end
else
    disp('error!!');
end
end