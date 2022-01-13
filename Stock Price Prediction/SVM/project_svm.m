load('data.mat');
X=data;
load('Y.mat');
load('X.mat');
c=25;
N=500;% no. of training data
C=zeros(N,1);
for i=1:N
    C(i)=c*i*2;
   
end
trs=2500;% index after which training data starts
C= C/(N*10);
G= zeros(N,N) ;
for i=1:N
    for j= 1:N
        G(i,j)=Y(trs+i)*Y(trs+j)*(rbf(X(trs+i,:),X(trs+j,:)));
    end
end 
one=ones(N,1);
fun = @(a)-a*(one)+(a*G*(transpose(a)))/2; % a is alpha matrix
a0 = zeros(1,N); %initializing alpha
for i=1:N
    a0(i) = rand()*i;
end
a0=a0*2/(N*10);
Aeq = zeros(N,1);
for i=1:N
    Aeq(i,1)=Y(trs+i,1);
end
Aeq=transpose(Aeq);
options = optimset('Algorithm','sqp','MaxIter',50,'MaxFunEvals',20000,'Display','iter');
a = fmincon(fun,a0,[],[],Aeq,0,zeros(1,N),C',[],options);
a1=1000;
a2=-1000;
Sum = zeros(N,1);
for i=1:N
    sum = 0;
    for j=1:N
        sum= sum + a(j)*Y(trs+j)*(rbf(X(trs+j,:),X(trs+i,:))); 
    end  
    Sum(i)=sum;
    if Y(trs+i)== 1
        if a1 > Sum(i)
            a1 = Sum(i);
        end
    else
        if a2 < Sum(i)
            a2 = Sum(i);
        end
    end
end 
b= -(a1+a2)/2;
 % predicting labels on test data
m=100;
sum = zeros(m,1);
pred = ones(m,1);
count=0;
for i=1:m
    s = 0;
    for j=1:N
        s= s + a(j)*Y(trs+j)*(rbf(X(trs+j,:),X(trs+N+i,:))); 
    end  
    sum(i)=s;
    if sum + b < 0
        pred(i)= -1;
    end    
    if pred(i)==Y(trs+N+i)
        count = count + 1;
    end
end