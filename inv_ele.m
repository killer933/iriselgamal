function f=inv_ele(a,n) 
%求a在模n下的逆元，穷举法
f=1;
for i=0:n-1
    if mod(a*i,n)==1
        f=i;
        break;
    end
end
