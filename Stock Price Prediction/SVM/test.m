m=200;
Ypred=zeros(m,1);
sum=zeros(m,1);
for i = 1:m
    
    for j=1:1000
        sum(i)= sum(i) + a(j)*Y(2000+j)*(rbf(data(2000+j),data(3000+i)));
    end
    if sum(i) > 0 
        Ypred(i)= +1;
    else
        Ypred(i)= -1;
    end
end
count=0;
for i=1:m
    if Y(3000+i)==Ypred(i)
        count= count + 1;
    end
end

        