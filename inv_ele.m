function f=inv_ele(a,n) 
%��a��ģn�µ���Ԫ����ٷ�
f=1;
for i=0:n-1
    if mod(a*i,n)==1
        f=i;
        break;
    end
end
