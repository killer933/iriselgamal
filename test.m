
%D =pdist2(person{1,1}(:,5)',person{1,1}(:,3)','hamming') %特征向量明文的汉明距离

%ElGamal 加密方案，取p=150001，本原元a=7，密钥d=113，  y=a^d mod p=66436
%cipertext={};
%素数p=19,生成元a=2,私钥d=9,则公钥y=2^9 mod 19=18
clc;clear
AAA=rand(100,6);
BBB=round(AAA);
CCC=rand(100,6);
DDD=round(CCC);
temppp=xor(BBB,DDD);
key=sum(sum(temppp==1))/600;

BBB(BBB==0) = 3;  %为加密做准备
BBB(BBB==1) = 5;
person{1,1}=BBB;

DDD(DDD==0) = 3;  %为加密做准备
DDD(DDD==1) = 5;
person{1,2}=DDD;
p=19;    %   150001;
a=2;    %7;
d=9;
pk=mc(a,d,p);    %基于二分法的降幂乘运算

cipertext=zeros(2,100,6,2);
for person_cnt=1:2
    for i=1:100
        for j=1:6
           k= unidrnd(10);
           c1=mc(a, k, p);    %mod(a^k,p)   基于二分法的降幂乘运算
           c2=person{1,person_cnt}(i,j)*mc(pk, k, p);  %mod(person{1,person_cnt}(i,j)*66436^k,p);
           cipertext(person_cnt,i,j,1)=c1;
           cipertext(person_cnt,i,j,2)=c2;  
        end
    end
end

%比对解密阶段
c=ones(100,1);
counter=0;
 
 for person_cnt=1:2
     for j=1:6
         for q=1:6
           for i=1:100
       ciptime1=cipertext(1,i,j,1).*cipertext(person_cnt,i,q,1);   %a
       ciptime2=cipertext(1,i,j,2).*cipertext(person_cnt,i,q,2);   %b
     result=inv_ele(ciptime1^d, p);
     c(i,1)=mod(ciptime2*result,p);
               if mod(c(i,1),15)==0
                  counter=counter+1;
               end
            end
        
 %disp(['第' num2str(1) '个人的第' num2str(j) '幅掌纹图像与第' num2str(person_cnt) '个人的第' num2str(q) '幅掌纹图像的海明距离为：' num2str(counter/100)]); 
%counter=0;

 disp(['The Hamming distance between the ' num2str(j) ' palmprint of the ' num2str(1) ' person and the '  num2str(q) ' palmprint of the ' num2str(person_cnt) ' person is: ' num2str(counter/100)]); 
counter=0;
          end
     end
 end

