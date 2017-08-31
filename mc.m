%大整数幂模
function y=mc(x, k, n)
c=1;
l=floor(log2(k))+1;
%binaryk=dec2bin(k);
for i=l-1:-1:0
    c=mod(c^2,n);
    if bitget(k,i+1)==1
        c=mod(c*x,n);
    end
end
y=c;