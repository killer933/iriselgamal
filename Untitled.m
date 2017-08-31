clc;clear;
A=2;
B=5;
p=19;    %   150001;
a=2;    %7;
d=9;
pk=mc(a,d,p);    %基于二分法的降幂乘运算

k= unidrnd(10);
c1=mc(a, k, p);
c2=A*mc(pk, k, p);

k= unidrnd(10);
d1=mc(a, k, p);
d2=B*mc(pk, k, p);

ciptime1=mod(c1*d1,p);   %a
ciptime2=mod(c2*d2,p);   %b
result=inv_ele(ciptime1^d, p);
ciptime2*result
c=mod(ciptime2*result,p);

% result=inv_ele(c1^d, p);
% c=mod(c2*result,p);
