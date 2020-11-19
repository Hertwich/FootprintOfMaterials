function output=cnty_sum(input,sec,dim)
if floor(size(input,dim)/sec)==size(input,dim)/sec
    n=size(input,dim)/sec;
    t=size(input);
    t(dim)=n;
    output=zeros(t);
    if dim==1
        for i=1:n
            output(i,:)=sum(input((i-1)*sec+1:i*sec,:),dim);
        end
    elseif dim==2
        for i=1:n
            output(:,i)=sum(input(:,(i-1)*sec+1:i*sec),dim);
        end
    elseif dim==3
        for i=1:n
            output(:,:,i)=sum(input(:,:,(i-1)*sec+1:i*sec),dim);
        end
    else      
        disp('error!!');
    end
else
    disp('error!!');
end
end